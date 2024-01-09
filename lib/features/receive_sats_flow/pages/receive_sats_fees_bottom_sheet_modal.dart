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

    return SizedBox(
      width: double.infinity,
      child: state.feeEstimate == null
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
                  ReceiveSatsFeeBottomSheetModalFeeSection(),
                  SizedBox(height: kSpacing9),
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

    final amountToReceive = ref.watch(
      displayBitcoinAmountProvider(
        state.amountToReceiveSat,
      ),
    );
    final unit = ref.watch(bitcoinUnitProvider);

    final localCurrency = ref.watch(localCurrencyProvider);
    final localCurrencyAmountToReceive =
        ref.watch(satToLocalProvider(state.amountToReceiveSat)).asData?.value ??
            0;

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
              '$amountToReceive ${unit.name.toUpperCase()}',
              style: textTheme.display5(
                Palette.neutral[80]!,
                FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '≈ ${localCurrencyAmountToReceive.toStringAsFixed(localCurrency.decimals)} ${localCurrency.code.toUpperCase()}',
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

class ReceiveSatsFeeBottomSheetModalFeeSection extends ConsumerWidget {
  const ReceiveSatsFeeBottomSheetModalFeeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;

    final state = ref.watch(receiveSatsControllerProvider);
    final notifier = ref.read(receiveSatsControllerProvider.notifier);

    final feeAmount = ref.watch(
      displayBitcoinAmountProvider(
        state.feeEstimate,
      ),
    );
    final amountToPay = ref.watch(
      displayBitcoinAmountProvider(
        state.amountToPaySat,
      ),
    );
    final unit = ref.watch(bitcoinUnitProvider);
    final localCurrency = ref.watch(localCurrencyProvider);
    final localCurrencyFeeAmount =
        ref.watch(satToLocalProvider(state.feeEstimate)).asData?.value ?? 0;

    final localCurrencyAmountToPay =
        ref.watch(satToLocalProvider(state.amountToPaySat)).asData?.value ?? 0;

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: kSpacing4,
          ),
          title: Text(
            'Estimated fee',
            style: textTheme.display2(
              Palette.neutral[80],
              FontWeight.w500,
            ),
          ),
          subtitle: Text(
            'Lightning channel opening fee',
            style: textTheme.caption1(
              Palette.neutral[50],
              FontWeight.w400,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$feeAmount ${unit.code.toUpperCase()}',
                style: textTheme.display2(
                  Palette.neutral[80],
                  FontWeight.w500,
                ),
              ),
              Text(
                '≈ ${localCurrencyFeeAmount.toStringAsFixed(localCurrency.decimals)} ${localCurrency.code.toUpperCase()}',
                style: textTheme.display1(
                  Palette.neutral[50],
                  FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: kSpacing4,
          ),
          title: Text(
            'Pass fees on to payer',
            style: textTheme.body3(
              Palette.neutral[80],
              FontWeight.w400,
            ),
          ),
          subtitle: Text(
            'Switch off to bear the fees.',
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
            'Total to pay',
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
              Text(
                '$amountToPay ${unit.code.toUpperCase()}',
                style: textTheme.display2(
                  Palette.success[50],
                  FontWeight.w700,
                ),
              ),
              Text(
                '≈ ${localCurrencyAmountToPay.toStringAsFixed(localCurrency.decimals)} ${localCurrency.code.toUpperCase()}',
                style: textTheme.display1(
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
