import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/enums/local_currency.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/receive_sats_controller.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/pages/receive_sats_fees_bottom_sheet_modal.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/widgets/buttons/rectangular_border_button.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReceiveSatsAmountScreen extends ConsumerWidget {
  const ReceiveSatsAmountScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final state = ref.watch(receiveSatsControllerProvider);
    final notifier = ref.read(receiveSatsControllerProvider.notifier);

    final unit = ref.watch(bitcoinUnitProvider);
    final amount = ref.watch(
      displayBitcoinAmountProvider(
        state.amountSat,
      ),
    );

    final localCurrency = ref.watch(localCurrencyProvider);
    final localCurrencyBalance =
        ref.watch(satToLocalProvider(state.amountSat)).asData?.value ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IntrinsicWidth(
                            child: TextField(
                              autofocus: true,
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: unit == BitcoinUnit.btc ? true : false,
                                signed: false,
                              ),
                              textAlign: TextAlign.center,
                              style: textTheme.display7(
                                  Palette.neutral[100], FontWeight.w600),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                hintText: '0',
                                hintStyle: textTheme.display7(
                                    Palette.neutral[60], FontWeight.w600),
                              ),
                              controller: state.amountController,
                              onChanged: notifier.amountChangeHandler,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ), // Adjust the width value for the desired spacing
                          Text(
                            unit.name.toUpperCase(),
                            textAlign: TextAlign.left,
                            style: textTheme.display1(
                                Palette.neutral[60], FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        '≈ ${localCurrencyBalance.toStringAsFixed(localCurrency.decimals)} ${localCurrency.code.toUpperCase()}',
                        style: textTheme.display2(
                          Palette.neutral[70],
                          FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          RectangularBorderButton(
            text: copy.confirmAmount,
            onPressed: amount == null || int.parse(amount) == 0
                ? null
                : () {
                    notifier.fetchFee();
                    showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      context: context,
                      elevation: 0,
                      builder: (context) =>
                          const ReceiveSatsFeesBottomSheetModal(),
                    );
                    return;
                  },
          ),
        ],
      ),
    );
  }
}
