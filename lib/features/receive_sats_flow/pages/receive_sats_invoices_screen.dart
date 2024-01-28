import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/pages/receive_sats_invoices_edit_bottom_sheet_modal.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/receive_sats_controller.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/receive_sats_reception_controller.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

class ReceiveSatsInvoicesScreen extends ConsumerWidget {
  const ReceiveSatsInvoicesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;
    final pageViewController = ref
        .read(pageViewControllerProvider(kReceiveSatsFlowPageViewId).notifier);

    final state = ref.watch(receiveSatsControllerProvider);

    // Watch the reception controller to start listening for the payment
    ref.watch(receiveSatsReceptionControllerProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) => pageViewController.previousPage(),
      child: Scaffold(
        backgroundColor: Palette.neutral[20],
        appBar: AppBar(
          title: Text(
            copy.receiveBitcoin,
            style: textTheme.display4(
              Palette.neutral[100]!,
              FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Palette.neutral[100]!,
          iconTheme: IconThemeData(color: Palette.neutral[100]!),
          actions: [
            CloseButton(
              color: Palette.neutral[70],
              onPressed: router.pop,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.fromLTRB(kSpacing4, 0, kSpacing4, kSpacing4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  copy.copyInvoiceOrScanQR,
                  style:
                      textTheme.display2(Palette.neutral[70], FontWeight.w400),
                ),
                const SizedBox(height: kSpacing6),
                const ReceiveSatsInvoicesScreenInvoicesCard(),
                const SizedBox(height: kSpacing4),
                state.isSwapInPossible
                    ? const ReceiveSatsInvoicesScreenAmountSection()
                    : state.isAmountTooSmallForSwapIn
                        ? const ReceiveSatsInvoicesScreenAmountTooSmallSection()
                        : state.isAmountTooBigForSwapIn
                            ? const ReceiveSatsInvoicesScreenAmountTooBigSection()
                            : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReceiveSatsInvoicesScreenInvoicesCard extends ConsumerWidget {
  const ReceiveSatsInvoicesScreenInvoicesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    final state = ref.watch(receiveSatsControllerProvider);

    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 24),
            spreadRadius: -12,
            blurRadius: 48,
            color: Color.fromRGBO(154, 170, 207, 0.55),
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kSpacing3),
        ),
        color: Colors.white,
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !state.isSwapInPossible
                ? const SizedBox()
                : ListTile(
                    title: Text(
                      state.partialOnChainAddress!,
                      style: textTheme.display2(
                        Palette.neutral[40],
                        FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      copy.copyBitcoinAddress,
                      style: textTheme.display2(
                        Palette.lilac[100],
                        FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    shape: Border(
                      bottom: BorderSide(
                        color: Palette.neutral[20]!,
                        width: 1,
                      ),
                    ),
                    onTap: () {
                      Clipboard.setData(
                              ClipboardData(text: state.onChainAddress!))
                          .then(
                        (_) {
                          // Optionally, show a confirmation message to the user.
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                copy.bitcoinAddressCopied,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
            ListTile(
              title: Text(
                state.partialInvoice!,
                style: textTheme.display2(
                  Palette.neutral[40],
                  FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                copy.copyLightningInvoice,
                style: textTheme.display2(
                  Palette.lilac[100],
                  FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              shape: Border(
                bottom: BorderSide(
                  color: Palette.neutral[20]!,
                  width: 1,
                ),
              ),
              onTap: () {
                Clipboard.setData(ClipboardData(text: state.invoice!.bolt11))
                    .then(
                  (_) {
                    // Optionally, show a confirmation message to the user.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(copy.lightningInvoiceCopied),
                      ),
                    );
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: kSpacing3, left: kSpacing5, right: kSpacing5),
              child: InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: state.bip21Uri!)).then(
                    (_) {
                      // Optionally, show a confirmation message to the user.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(copy.paymentRequestCopied),
                        ),
                      );
                    },
                  );
                },
                child: Column(
                  children: [
                    QrImageView(
                      data: state.bip21Uri!,
                    ),
                    Text(
                      state.isSwapInPossible
                          ? copy
                              .canBeScannedByOrCopiedToBothBitcoinAndLightningWallets
                              .toUpperCase()
                          : copy
                              .canBeScannedByOrCopiedToLightningCompatibleWallets
                              .toUpperCase(),
                      style: textTheme.caption1(
                        Palette.neutral[50],
                        FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: kSpacing3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: DynamicIcon(
                    icon: Icons.edit,
                    color: Palette.neutral[70],
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      context: context,
                      elevation: 0,
                      builder: (context) =>
                          const ReceiveSatsInvoicesEditBottomSheetModal(),
                    );
                  },
                ),
                const SizedBox(
                  width: kSpacing4,
                ),
                Container(
                  height: 24,
                  width: 1,
                  color: Palette.neutral[40],
                ),
                const SizedBox(
                  width: kSpacing4,
                ),
                IconButton(
                  icon: DynamicIcon(
                    icon: 'assets/icons/share.svg',
                    color: Palette.neutral[70],
                  ),
                  onPressed: () {
                    Share.share(state.bip21Uri!);
                  },
                ),
              ],
            ),
            const SizedBox(height: kSpacing4),
          ],
        ),
      ),
    );
  }
}

class ReceiveSatsInvoicesScreenAmountSection extends ConsumerWidget {
  const ReceiveSatsInvoicesScreenAmountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;

    final state = ref.watch(receiveSatsControllerProvider);
    final amountToPay = ref.watch(
      displayBitcoinAmountProvider(
        state.amountToPaySat,
      ),
    );
    final unit = ref.watch(
      bitcoinUnitProvider,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kSpacing3,
          ),
          child: RichText(
            text: TextSpan(
              text: copy.whenSharingOnlyTheBitcoinAddressPart1,
              style: textTheme.body2(Palette.neutral[60], FontWeight.w500),
              children: [
                TextSpan(
                  text: copy.whenSharingOnlyTheBitcoinAddressPart2,
                  style: textTheme.body2(Palette.neutral[60], FontWeight.w700),
                ),
                TextSpan(
                  text: copy.whenSharingOnlyTheBitcoinAddressPart3,
                  style: textTheme.body2(Palette.neutral[60], FontWeight.w500),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: kSpacing2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(
                    text: '${amountToPay!} ${unit.code}',
                  ),
                ).then(
                  (_) {
                    // Optionally, show a confirmation message to the user.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('${copy.amountToPayCopiedIn} ${unit.code}'),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.copy),
              iconSize: 16,
              color: Palette.lilac[100],
            ),
            Text(
              amountToPay!,
              style: textTheme.display3(
                Palette.neutral[80],
                FontWeight.w400,
              ),
            ),
            Text(
              ' ${unit.code}',
              style: textTheme.caption1(
                Palette.neutral[60],
                FontWeight.w600,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class ReceiveSatsInvoicesScreenAmountTooSmallSection extends ConsumerWidget {
  const ReceiveSatsInvoicesScreenAmountTooSmallSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;

    final state = ref.watch(receiveSatsControllerProvider);
    final minAmount = ref.watch(
      displayBitcoinAmountProvider(
        state.onChainMinAmount,
      ),
    );
    final unit = ref.watch(
      bitcoinUnitProvider,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kSpacing3,
          ),
          child: RichText(
            text: TextSpan(
              text: copy.minAmountToEnableOnChainReceivingPart1,
              style: textTheme.body2(Palette.neutral[60], FontWeight.w500),
              children: [
                TextSpan(
                  text: copy.minAmountToEnableOnChainReceivingPart2,
                  style: textTheme.body2(Palette.neutral[60], FontWeight.w700),
                ),
                TextSpan(
                  text:
                      '${copy.minAmountToEnableOnChainReceivingPart3} $minAmount ${unit.code}.',
                  style: textTheme.body2(Palette.neutral[60], FontWeight.w500),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class ReceiveSatsInvoicesScreenAmountTooBigSection extends ConsumerWidget {
  const ReceiveSatsInvoicesScreenAmountTooBigSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;

    final state = ref.watch(receiveSatsControllerProvider);
    final maxAmount = ref.watch(
      displayBitcoinAmountProvider(
        state.onChainMaxAmount,
      ),
    );
    final unit = ref.watch(
      bitcoinUnitProvider,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kSpacing3,
          ),
          child: RichText(
            text: TextSpan(
              text: copy.maxAmountToEnableOnChainReceivingPart1,
              style: textTheme.body2(Palette.neutral[60], FontWeight.w500),
              children: [
                TextSpan(
                  text: copy.maxAmountToEnableOnChainReceivingPart2,
                  style: textTheme.body2(Palette.neutral[60], FontWeight.w700),
                ),
                TextSpan(
                  text:
                      '${copy.maxAmountToEnableOnChainReceivingPart3} $maxAmount ${unit.code}.',
                  style: textTheme.body2(Palette.neutral[60], FontWeight.w500),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
