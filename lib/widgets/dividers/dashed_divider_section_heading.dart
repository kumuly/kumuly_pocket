import 'package:flutter/material.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/dividers/dashed_divider.dart';

class DashedDividerSectionHeading extends StatelessWidget {
  final String title;

  const DashedDividerSectionHeading({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: kSpacing2,
            top: kSpacing3,
            right: kSpacing2,
            bottom: kSpacing1,
          ),
          child: Text(
            title,
            style: textTheme.body1(
              Palette.neutral[100],
              FontWeight.w700,
            ),
          ),
        ),
        DashedDivider(
          color: Palette.neutral[70]!,
          thickness: 1,
        ),
      ],
    );
  }
}
