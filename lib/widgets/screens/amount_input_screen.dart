import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/enums/local_currency.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/widgets/buttons/rectangular_border_button.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AmountInputScreen extends ConsumerWidget {
  AmountInputScreen({
    super.key,
    required this.inputAmountSat,
    this.appBar,
    required this.label,
    this.readOnly = false,
    this.onChangeHandler,
    this.confirmationHandler,
    textEditingController,
    focusNode,
  })  : textEditingController =
            textEditingController ?? TextEditingController(),
        focusNode = focusNode ?? FocusNode();

  final int inputAmountSat;
  final AppBar? appBar;
  final String label;
  final bool readOnly;
  final void Function(String)? onChangeHandler;
  final void Function()? confirmationHandler;
  final TextEditingController textEditingController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final unit = ref.watch(bitcoinUnitProvider);

    final localCurrency = ref.watch(localCurrencyProvider);
    final localCurrencyBalance =
        ref.watch(satToLocalProvider(inputAmountSat)).asData?.value ?? 0;

    return Scaffold(
      appBar: appBar,
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
                  label,
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
                              controller: textEditingController,
                              focusNode: focusNode,
                              readOnly: readOnly,
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
                              onChanged: onChangeHandler,
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
            onPressed: confirmationHandler,
          ),
        ],
      ),
    );
  }
}
