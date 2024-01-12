import 'package:flutter/material.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:lottie/lottie.dart';

class LabelWithLoadingAnimation extends StatelessWidget {
  final String label;
  final TextStyle? style;

  const LabelWithLoadingAnimation(
    this.label, {
    super.key,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: style ??
              textTheme.display4(
                Palette.neutral[100],
                FontWeight.w600,
              ),
        ),
        const SizedBox(height: kSpacing2),
        LottieBuilder.asset(
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
      ],
    );
  }
}
