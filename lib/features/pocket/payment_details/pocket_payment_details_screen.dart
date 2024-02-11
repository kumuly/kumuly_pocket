import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/pocket/payment_details/pocket_payment_details_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/amounts/bitcoin_amount_display.dart';
import 'package:kumuly_pocket/widgets/amounts/local_currency_amount_display.dart';
import 'package:kumuly_pocket/widgets/dividers/dashed_divider.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/loaders/label_with_loading_animation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PocketPaymentDetailsScreen extends ConsumerWidget {
  const PocketPaymentDetailsScreen({
    super.key,
    required this.hash,
  });

  final String hash;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    final state = ref.watch(pocketPaymentsDetailsControllerProvider(hash));

    return state.when(
      loading: () => const PocketPaymentDetailsLoadingScreen(),
      error: (error, _) => PocketPaymentDetailsErrorScreen(error: error),
      data: (state) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    state.paymentDetails.formattedTimestamp ?? copy.pending,
                    style: textTheme.display2(
                        Palette.neutral[50], FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: kSpacing3),
                  Image.asset(
                    state.paymentDetails.isIncoming
                        ? 'assets/illustrations/coins_incoming.png'
                        : 'assets/illustrations/coins_outgoing.png',
                    width: 112,
                  ),
                  const SizedBox(height: kSpacing3),
                  Text(
                    state.paymentDetails.isIncoming
                        ? copy.successfullyReceived
                        : copy.successfullySent,
                    style: textTheme.display5(
                      state.paymentDetails.isIncoming
                          ? Palette.success[50]
                          : Palette.lilac[100],
                      FontWeight.w500,
                    ),
                  ),
                  BitcoinAmountDisplay(
                    prefix: state.paymentDetails.isIncoming ? '+ ' : '- ',
                    amountSat: state.paymentDetails.amountSat,
                    amountStyle: textTheme.display7(
                      state.paymentDetails.isIncoming
                          ? Palette.success[50]
                          : Palette.lilac[100],
                      FontWeight.bold,
                    ),
                    hideUnit: true,
                  ),
                  LocalCurrencyAmountDisplay(
                    prefix: '≈ ',
                    showSymbol: true,
                    showCode: false,
                    amountSat: state.paymentDetails.amountSat,
                    amountStyle: textTheme.display3(
                      Palette.neutral[60],
                      FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: kSpacing7),
                ],
              ),
              const DashedDivider(),
              ListTile(
                minVerticalPadding: kSpacing4,
                title: Text(
                  copy.paymentStatus,
                  style: textTheme.display2(
                    Palette.neutral[60],
                    FontWeight.w500,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(
                    top: kSpacing2,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Palette.success[50],
                        size: 24,
                      ),
                      const SizedBox(width: kSpacing1),
                      Expanded(
                        child: Text(
                          state.paymentDetails.isIncoming
                              ? copy
                                  .paymentReceivedAndFundsAvailableInYourPocketForInstantSpending
                              : copy.instantPaymentMadeSuccessfully,
                          style: textTheme.display2(
                            Palette.neutral[80],
                            FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const DashedDivider(),
              ListTile(
                minVerticalPadding: kSpacing4,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/lightning_avatar.png',
                          width: 32,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: kSpacing2,
                    ),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${copy.paymentHash}・${copy.lightningNetwork}',
                            style: textTheme.display2(
                              Palette.neutral[60],
                              FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${hash.substring(0, 8)}...${hash.substring(hash.length - 8)}',
                            style: textTheme.body2(
                              Palette.lilac[100],
                              FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Palette.neutral[40]!, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(kSpacing1),
                        child: DynamicIcon(
                          icon: Icons.copy,
                          color: Palette.neutral[70],
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // Copy hash to clipboard
                  Clipboard.setData(ClipboardData(text: hash));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(copy.paymentHashCopiedToClipboard),
                    ),
                  );
                },
              ),
              const DashedDivider(),
              ListTile(
                minVerticalPadding: kSpacing4,
                title: Text(
                  copy.networkFee,
                  style: textTheme.display2(
                    Palette.neutral[60],
                    FontWeight.w500,
                  ),
                ),
                subtitle: BitcoinAmountDisplay(
                  amountSat: state.paymentDetails.feeAmountSat,
                  amountStyle: textTheme.display2(
                    Palette.neutral[80],
                    FontWeight.w500,
                  ),
                ),
              ),
              const DashedDivider(),
              const SizedBox(height: kSpacing7),
            ],
          ),
        ),
      ),
    );
  }
}

class PocketPaymentDetailsLoadingScreen extends StatelessWidget {
  const PocketPaymentDetailsLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LabelWithLoadingAnimation(copy.obtainingDetails),
        ],
      ),
    );
  }
}

class PocketPaymentDetailsErrorScreen extends StatelessWidget {
  const PocketPaymentDetailsErrorScreen({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(error.toString())),
    );
  }
}
