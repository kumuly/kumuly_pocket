import 'package:flutter/material.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class WalletHeader extends StatelessWidget {
  const WalletHeader({
    super.key,
    this.actions,
    required this.title,
    required this.balance,
    required this.unit,
    required this.balanceInFiat,
    required this.fiatCurrency,
  });

  final String title;
  final String balance;
  final String unit;
  final String balanceInFiat;
  final String fiatCurrency;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
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
            height: kSmallSpacing,
          ),
          Text(
            '$balance $unit',
            style: textTheme.display7(
              Palette.neutral[120],
              FontWeight.w700,
            ),
          ),
          Text(
            '≈ $balanceInFiat $fiatCurrency',
            style: textTheme.display2(
              Palette.neutral[70],
              FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: kLargeSpacing,
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
