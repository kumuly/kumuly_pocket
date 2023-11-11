import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/generation/receive_sats_generation_controller.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/widgets/buttons/rectangular_border_button.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class ReceiveSatsAmountScreen extends ConsumerWidget {
  const ReceiveSatsAmountScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final unit = ref.watch(bitcoinUnitProvider);
    final amount = ref.watch(
      displayBitcoinAmountProvider(
        ref.watch(receiveSatsGenerationControllerProvider).amountSat,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          copy.receiveBitcoin,
          style: Theme.of(context).textTheme.display4(
                Palette.neutral[100]!,
                FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Palette.neutral[100]!,
        iconTheme: IconThemeData(color: Palette.neutral[100]!),
      ),
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  copy.howMuchDoYouWantToReceive,
                  style:
                      textTheme.display3(Palette.neutral[70], FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: kSpacing2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IntrinsicWidth(
                        child: TextField(
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: textTheme.display7(
                              Palette.neutral[100], FontWeight.w600),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '0',
                            hintStyle: textTheme.display7(
                                Palette.neutral[60], FontWeight.w600),
                          ),
                          onChanged: ref
                              .read(receiveSatsGenerationControllerProvider
                                  .notifier)
                              .amountChangeHandler,
                        ),
                      ),
                      const SizedBox(
                          width:
                              5), // Adjust the width value for the desired spacing
                      Text(
                        unit.name.toUpperCase(),
                        textAlign: TextAlign.left,
                        style: textTheme.display1(
                            Palette.neutral[60], FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          RectangularBorderButton(
            text: copy.confirmAmount,
            onPressed: amount == null || amount == 0
                ? null
                : () {
                    ref
                        .read(receiveSatsGenerationControllerProvider.notifier)
                        .fetchSwapInfo();
                    showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (context) => const ReceiveSatsBottomSheetModal(),
                    );
                    return;
                  },
          ),
        ],
      ),
    );
  }
}

class ReceiveSatsBottomSheetModal extends ConsumerWidget {
  const ReceiveSatsBottomSheetModal({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final unit = ref.watch(bitcoinUnitProvider);
    final amount = ref.watch(
      displayBitcoinAmountProvider(
        ref.watch(receiveSatsGenerationControllerProvider).amountSat,
      ),
    );
    final onChainFeeEstimate =
        ref.watch(receiveSatsGenerationControllerProvider).swapFeeEstimate;

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: kSpacing3),
          Text(
            copy.amountToReceive,
            style: textTheme.display5(
              Colors.green,
              FontWeight.w600,
            ),
          ),
          Text(
            '$amount ${unit.name.toUpperCase()}',
            style: textTheme.display5(
              Palette.neutral[80]!,
              FontWeight.w500,
            ),
          ),
          const SizedBox(height: kSpacing2),
          Text(
            '+',
            style: textTheme.display5(
              Colors.green,
              FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: kSpacing8,
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      !ref
                              .watch(receiveSatsGenerationControllerProvider)
                              .isSwapAvailable
                          ? Text(
                              copy.unavailable,
                              style: textTheme.display2(
                                Palette.neutral[80],
                                FontWeight.w500,
                              ),
                            )
                          : onChainFeeEstimate == null
                              ? const CircularProgressIndicator()
                              : Text(
                                  '$onChainFeeEstimate ${BitcoinUnit.sat.name.toUpperCase()}',
                                  style: textTheme.display2(
                                    Palette.neutral[80],
                                    FontWeight.w500,
                                  ),
                                ),
                      Text(
                        copy.estimatedFee.toUpperCase(),
                        style: textTheme.caption1(
                          Palette.neutral[50],
                          FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: kSpacing3),
                      const DynamicIcon(
                        icon: AssetImage('assets/icons/btc_avatar.png'),
                        size: 32,
                      ),
                      const SizedBox(height: kSpacing3),
                      Text(
                        copy.ifYouReceiveFrom,
                        style: textTheme.display2(
                          Palette.neutral[50],
                          FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        copy.theBitcoinNetwork.toUpperCase(),
                        style: textTheme.caption1(
                          Palette.neutral[70],
                          FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        copy.bitcoinProcessingTime.toUpperCase(),
                        style: textTheme.caption1(
                          Palette.neutral[50],
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                VerticalDivider(
                  width: 2.0,
                  color: Palette.neutral[50]!,
                  thickness: 1,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '0 ${unit.name.toUpperCase()}',
                        style: textTheme.display2(
                          Palette.neutral[80],
                          FontWeight.w500,
                        ),
                      ),
                      Text(
                        copy.inFees.toUpperCase(),
                        style: textTheme.caption1(
                          Palette.neutral[50],
                          FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: kSpacing3),
                      const DynamicIcon(
                        icon: AssetImage('assets/icons/lightning_avatar.png'),
                        size: 32.0,
                      ),
                      const SizedBox(height: kSpacing3),
                      Text(
                        copy.ifYouReceiveFrom,
                        style: textTheme.display2(
                          Palette.neutral[50],
                          FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        copy.theLightningNetwork.toUpperCase(),
                        style: textTheme.caption1(
                          Palette.neutral[70],
                          FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        copy.lightningProcessingTime.toUpperCase(),
                        style: textTheme.caption1(
                          Palette.neutral[50],
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: kSpacing8),
          Text(
            copy.unifiedQRExplanation,
            style: textTheme.body3(
              Palette.neutral[60],
              FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: kSpacing2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              PrimaryFilledButton(
                text: copy.generate,
                fillColor: Palette.neutral[120],
                textColor: Colors.white,
                onPressed: () async {
                  try {
                    final invoiceCreation = ref
                        .read(receiveSatsGenerationControllerProvider.notifier)
                        .createInvoice();
                    showTransitionDialog(context, copy.oneMomentPlease);
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
                    // Set an error message to the state and show it
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
          ),
          const SizedBox(height: kSpacing3),
        ],
      ),
    );
  }
}
