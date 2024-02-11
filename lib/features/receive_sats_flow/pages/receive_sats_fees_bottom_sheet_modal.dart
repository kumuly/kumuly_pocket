import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/receive_sats_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/amounts/bitcoin_amount_display.dart';
import 'package:kumuly_pocket/widgets/amounts/local_currency_amount_display.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:kumuly_pocket/widgets/loaders/label_with_loading_animation.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class ReceiveSatsFeesBottomSheetModal extends ConsumerWidget {
  const ReceiveSatsFeesBottomSheetModal({
    super.key,
  });

  get textTheme => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final state = ref.watch(receiveSatsControllerProvider);

    return SizedBox(
      width: double.infinity,
      child: state.feeEstimate == null
          ? Center(
              heightFactor: 5,
              child: LabelWithLoadingAnimation(
                '${copy.estimatingFees}...',
              ),
            )
          : const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: kSpacing3),
                  ReceiveSatsFeesBottomSheetModalAmountHeader(),
                  SizedBox(height: kSpacing8),
                  ReceiveSatsFeeBottomSheetModalFeeSection(),
                  SizedBox(height: kSpacing9),
                  ReceiveSatsFeeBottomSheetModalFeeBearerSelection(),
                  SizedBox(height: kSpacing2),
                  ReceiveSatsFeeBottomSheetModalGenerateInvoiceButton(),
                  SizedBox(height: kSpacing5),
                ],
              ),
            ),
    );
  }
}

class ReceiveSatsFeesBottomSheetModalAmountHeader extends ConsumerWidget {
  const ReceiveSatsFeesBottomSheetModalAmountHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final state = ref.watch(receiveSatsControllerProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kSpacing2,
            vertical: kSpacing1,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // The first close button is just for centering the text with spaceBetween
              const CloseButton(
                color: Colors.transparent,
              ),
              Text(
                copy.amountToReceive,
                style: textTheme.display5(
                  Colors.green,
                  FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              CloseButton(
                color: Palette.neutral[70],
                onPressed: router.pop,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BitcoinAmountDisplay(
              amountSat: state.amountToReceiveSat,
              amountStyle: textTheme.display5(
                Palette.neutral[80]!,
                FontWeight.w500,
              ),
            ),
            LocalCurrencyAmountDisplay(
              prefix: '≈ ',
              amountSat: state.amountToReceiveSat,
              amountStyle: textTheme.display3(
                Palette.neutral[50],
                FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: kSpacing2),
        Icon(
          Icons.add,
          color: Palette.success[50],
          size: 24,
        ),
      ],
    );
  }
}

class ReceiveSatsFeeBottomSheetModalFeeSection extends ConsumerWidget {
  const ReceiveSatsFeeBottomSheetModalFeeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;

    final state = ref.watch(receiveSatsControllerProvider);

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: kSpacing4,
          ),
          title: Text(
            copy.expectedFee,
            style: textTheme.display2(
              Palette.neutral[80],
              FontWeight.w500,
            ),
          ),
          subtitle: Text(
            copy.lightningChannelOpeningFee,
            style: textTheme.caption1(
              Palette.neutral[50],
              FontWeight.w400,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BitcoinAmountDisplay(
                amountSat: state.feeEstimate,
                amountStyle: textTheme.display2(
                  Palette.neutral[80],
                  FontWeight.w500,
                ),
              ),
              LocalCurrencyAmountDisplay(
                amountSat: state.feeEstimate,
                amountStyle: textTheme.display1(
                  Palette.neutral[50],
                  FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kSpacing4,
          ),
          child: Divider(
            height: 1,
            color: Palette.neutral[40]!,
            thickness: 1,
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: kSpacing4,
          ),
          title: Text(
            copy.invoiceTotal,
            style: textTheme.display2(
              Palette.success[50],
              FontWeight.w700,
            ),
          ),
          titleAlignment: ListTileTitleAlignment.top,
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BitcoinAmountDisplay(
                amountSat: state.amountToPaySat,
                amountStyle: textTheme.display2(
                  Palette.success[50],
                  FontWeight.w700,
                ),
              ),
              LocalCurrencyAmountDisplay(
                prefix: '≈ ',
                amountSat: state.amountToPaySat,
                amountStyle: textTheme.display1(
                  Palette.neutral[50],
                  FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReceiveSatsFeeBottomSheetModalFeeBearerSelection extends ConsumerWidget {
  const ReceiveSatsFeeBottomSheetModalFeeBearerSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final state = ref.watch(receiveSatsControllerProvider);
    final notifier = ref.read(receiveSatsControllerProvider.notifier);

    if (state.feeEstimate! > 0) {
      return SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: kSpacing4,
        ),
        title: Text(
          copy.addFeeToInvoice,
          style: textTheme.body3(
            Palette.neutral[80],
            FontWeight.w400,
          ),
        ),
        subtitle: Text(
          copy.switchOffToBearTheFeeYourself,
          style: textTheme.caption1(
            Palette.neutral[50],
            FontWeight.w400,
          ),
        ),
        value: !state.assumeFee,
        inactiveTrackColor: Palette.neutral[40],
        inactiveThumbColor: Palette.neutral[60],
        trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
        activeColor: Palette.russianViolet[100],
        onChanged: notifier.passFeesToPayerChangeHandler,
      );
    } else {
      return const SizedBox();
    }
  }
}

class ReceiveSatsFeeBottomSheetModalGenerateInvoiceButton
    extends ConsumerWidget {
  const ReceiveSatsFeeBottomSheetModalGenerateInvoiceButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;
    final notifier = ref.read(receiveSatsControllerProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        PrimaryFilledButton(
          text: copy.generateInvoice,
          fillColor: Palette.neutral[120],
          textColor: Colors.white,
          onPressed: () async {
            try {
              final invoiceCreation = notifier.createInvoice();
              final swapCreation = notifier.createOnChainAddress();
              // Show loading dialog
              showTransitionDialog(context, copy.oneMomentPlease);
              // Remove the keyboard from inputting the amount
              FocusScope.of(context).unfocus();
              // Wait for the invoice to be created
              await Future.wait([invoiceCreation, swapCreation]);
              // Pop one time for the bottom sheet
              router.pop();
              // Pop another time for the transition modal
              router.pop();
              ref
                  .read(pageViewControllerProvider(
                    kReceiveSatsFlowPageViewId,
                  ).notifier)
                  .nextPage();
            } catch (e) {
              print(e);
              // Pop the transition dialog
              router.pop();
            }
          },
          trailingIcon: const Icon(
            Icons.qr_code,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
