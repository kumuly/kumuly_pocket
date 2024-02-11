import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/local_currency.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';

class LocalCurrencyAmountDisplay extends ConsumerWidget {
  const LocalCurrencyAmountDisplay({
    super.key,
    required this.amountSat,
    required this.amountStyle,
    this.unitSymbolStyle,
    this.unitCodeStyle,
    this.showSymbol = false,
    this.showCode = true,
    this.prefix,
    this.prefixStyle,
  });

  final int? amountSat;
  final TextStyle amountStyle;
  final TextStyle? unitSymbolStyle;
  final TextStyle? unitCodeStyle;
  final bool showSymbol;
  final bool showCode;
  final String? prefix;
  final TextStyle? prefixStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localCurrency = ref.watch(localCurrencyProvider);
    final amount = ref.watch(satToLocalProvider(amountSat)).asData?.value ?? 0;

    return amountSat == null
        ? const SizedBox()
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefix != null)
                Text(
                  prefix!,
                  style: prefixStyle ?? amountStyle,
                ),
              if (showSymbol)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      localCurrency.symbol,
                      style: unitSymbolStyle ?? amountStyle,
                    ),
                    const SizedBox(width: kSpacing1 / 2),
                  ],
                ),
              Text(
                amount.toStringAsFixed(localCurrency.decimals),
                style: amountStyle,
              ),
              if (showCode)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: kSpacing1 / 2),
                    Text(
                      localCurrency.code,
                      style: unitCodeStyle ?? amountStyle,
                    ),
                  ],
                ),
            ],
          );
  }
}
