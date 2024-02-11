import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/amounts/bitcoin_amount_display.dart';
import 'package:kumuly_pocket/widgets/amounts/local_currency_amount_display.dart';

class WalletHeader extends ConsumerWidget {
  const WalletHeader({
    super.key,
    this.actions,
    required this.title,
    required this.balanceSat,
  });

  final String title;
  final int? balanceSat;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(children: [
          Text(
            title,
            style: textTheme.labelSmall!.copyWith(
              letterSpacing: 2,
              color: Palette.neutral[70],
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: kSpacing2,
          ),
          balanceSat == null
              ? const SizedBox(
                  height: 32,
                  width: 32,
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    BitcoinAmountDisplay(
                      amountSat: balanceSat,
                      amountStyle: textTheme.display7(
                        Palette.neutral[120],
                        FontWeight.w700,
                      ),
                    ),
                    LocalCurrencyAmountDisplay(
                      prefix: '≈ ',
                      amountSat: balanceSat,
                      amountStyle: textTheme.display2(
                        Palette.neutral[70],
                        FontWeight.normal,
                      ),
                    ),
                  ],
                ),
          const SizedBox(
            height: kSpacing8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: actions?.map((action) {
                  // Add padding between actions
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                    ), // Adjust the spacing as needed
                    child: action,
                  );
                }).toList() ??
                [],
          ),
        ])
      ],
    );
  }
}
