import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';

class BitcoinAmountDisplay extends ConsumerWidget {
  const BitcoinAmountDisplay({
    super.key,
    required this.amountSat,
    required this.amountStyle,
    this.unitSymbolStyle,
    this.unitCodeStyle,
    this.prefix,
    this.prefixStyle,
    this.hideUnit = false,
  });

  final int? amountSat;
  final TextStyle amountStyle;
  final TextStyle? unitSymbolStyle;
  final TextStyle? unitCodeStyle;
  final String? prefix;
  final TextStyle? prefixStyle;
  final bool hideUnit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountDisplay = ref.watch(displayBitcoinAmountProvider(amountSat));
    final bitcoinUnit = ref.watch(bitcoinUnitProvider);

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
              if (!hideUnit && bitcoinUnit == BitcoinUnit.sat)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bitcoinUnit.symbol,
                      style: unitSymbolStyle ?? amountStyle,
                    ),
                    const SizedBox(width: kSpacing1 / 2),
                  ],
                ),
              Text(amountDisplay!, style: amountStyle),
              if (!hideUnit && bitcoinUnit != BitcoinUnit.sat)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: kSpacing1 / 2),
                    Text(
                      bitcoinUnit.code,
                      style: unitCodeStyle ?? amountStyle,
                    ),
                  ],
                )
            ],
          );
  }
}
