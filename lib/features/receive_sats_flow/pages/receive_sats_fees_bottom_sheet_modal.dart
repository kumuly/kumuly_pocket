import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/enums/local_currency.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/receive_sats_controller.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:lottie/lottie.dart';

class ReceiveSatsFeesBottomSheetModal extends ConsumerWidget {
  const ReceiveSatsFeesBottomSheetModal({
    super.key,
  });

  get textTheme => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(receiveSatsControllerProvider);
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: state.isFetchingFeeInfo
          ? Center(
              heightFactor: 10,
              child: LottieBuilder.asset(
                'assets/lottie/loading_animation.json',
                width: 96.0,
                height: 24.0,
                delegates: LottieDelegates(
                  values: [
                    ValueDelegate.color(
                      const ['**'],
                      value: Palette.neutral[50],
                    ),
                  ],
                ),
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
                  ReceiveSatsFeesBottomSheetModalFeesSection(),
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

    final unit = ref.watch(bitcoinUnitProvider);
    final amount = ref.watch(
      displayBitcoinAmountProvider(
        state.amountSat,
      ),
    );

    final localCurrency = ref.watch(localCurrencyProvider);
    final localCurrencyBalance =
        ref.watch(satToLocalProvider(state.amountSat)).asData?.value ?? 0;

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
            Text(
              '$amount ${unit.name.toUpperCase()}',
              style: textTheme.display5(
                Palette.neutral[80]!,
                FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '≈ ${localCurrencyBalance.toStringAsFixed(localCurrency.decimals)} ${localCurrency.code.toUpperCase()}',
              style: textTheme.display3(
                Palette.neutral[50],
                FontWeight.w500,
              ),
              textAlign: TextAlign.center,
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

class ReceiveSatsFeesBottomSheetModalFeesSection extends ConsumerWidget {
  const ReceiveSatsFeesBottomSheetModalFeesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final state = ref.watch(receiveSatsControllerProvider);
    final notifier = ref.read(receiveSatsControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: state.isSwapAvailable
                    ? ReceiveSatsFeesBottomSheetModalFeesSectionColumn(
                        feeAmount: state.onChainFeeEstimate!,
                        iconAssetName: 'assets/icons/bitcoin_b_angle.svg',
                        networkName: copy.theBitcoinNetwork,
                        processingTimeInfo: copy.bitcoinProcessingTime,
                      )
                    : const ReceiveSatsFeesBottomSheetModalFeesSectionUnavailableColumn(),
              ),
              VerticalDivider(
                width: 1,
                color: Palette.neutral[50]!,
                thickness: 1,
              ),
              Expanded(
                child: ReceiveSatsFeesBottomSheetModalFeesSectionColumn(
                  feeAmount: state.lightningFeeEstimate!,
                  iconAssetName: 'assets/icons/lightning_strike.svg',
                  networkName: copy.theLightningNetwork,
                  processingTimeInfo: copy.lightningProcessingTime,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: kSpacing9),
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Switch(
                    value: !state.assumeFees,
                    inactiveTrackColor: Palette.neutral[40],
                    inactiveThumbColor: Palette.neutral[60],
                    trackOutlineColor:
                        MaterialStateProperty.all(Colors.transparent),
                    activeColor: Palette.russianViolet[100],
                    onChanged: notifier.passFeesToPayerChangeHandler,
                  ),
                  const SizedBox(
                    width: kSpacing2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pass fees on to payer',
                        style: textTheme.body3(
                          Palette.neutral[80],
                          FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Switch off to bear the fees.',
                        style: textTheme.caption1(
                          Palette.neutral[50],
                          FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ReceiveSatsFeesBottomSheetModalFeesSectionColumn extends ConsumerWidget {
  const ReceiveSatsFeesBottomSheetModalFeesSectionColumn({
    required this.feeAmount,
    required this.iconAssetName,
    required this.networkName,
    required this.processingTimeInfo,
    super.key,
  });

  final int feeAmount;
  final String iconAssetName;
  final String networkName;
  final String processingTimeInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final state = ref.watch(receiveSatsControllerProvider);
    final notifier = ref.read(receiveSatsControllerProvider.notifier);

    return Column(
      children: [
        Text(
          '$feeAmount ${BitcoinUnit.sat.name.toUpperCase()}',
          style: textTheme.display2(
            Palette.neutral[80],
            FontWeight.w500,
          ),
        ),
        const SizedBox(height: kSpacing1 / 4),
        Text(
          copy.estimatedFee.toUpperCase(),
          style: textTheme.caption1(
            Palette.neutral[50],
            FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: kSpacing3,
        ),
        Container(
          height: 32,
          width: 32,
          padding: const EdgeInsets.all(kSpacing1 / 2),
          decoration: BoxDecoration(
            color: Palette.neutral[20],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DynamicIcon(
            icon: iconAssetName,
            color: Palette.neutral[50],
            size: 24,
          ),
        ),
        const SizedBox(
          height: kSpacing2,
        ),
        Text(
          copy.ifPaidFrom,
          style: textTheme.display2(
            Palette.neutral[50],
            FontWeight.w500,
          ),
        ),
        const SizedBox(height: kSpacing1 / 2),
        Text(
          networkName.toUpperCase(),
          style: textTheme.caption1(
            Palette.neutral[70],
            FontWeight.bold,
          ),
        ),
        const SizedBox(height: kSpacing1 / 2),
        Text(
          processingTimeInfo.toUpperCase(),
          style: textTheme.caption1(
            Palette.neutral[50],
            FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ReceiveSatsFeesBottomSheetModalFeesSectionUnavailableColumn
    extends ConsumerWidget {
  const ReceiveSatsFeesBottomSheetModalFeesSectionUnavailableColumn(
      {this.minAmount, this.maxAmount, super.key});

  final int? minAmount;
  final int? maxAmount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final state = ref.watch(receiveSatsControllerProvider);
    final notifier = ref.read(receiveSatsControllerProvider.notifier);

    return Column(
      children: [],
    );
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
              // Show loading dialog
              showTransitionDialog(context, copy.oneMomentPlease);
              // Remove the keyboard from inputting the amount
              FocusScope.of(context).unfocus();
              // Wait for the invoice to be created
              await invoiceCreation;
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
              // Pop  the transition dialog
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
