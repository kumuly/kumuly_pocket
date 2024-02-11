import 'package:flutter/material.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class SalesList extends StatelessWidget {
  const SalesList({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: textTheme.caption1(
              Palette.neutral[120],
              FontWeight.bold,
              wordSpacing: 1,
            ),
          ),
        ),
        Column(
          children: List.generate(
            1,
            (index) => ListTile(
              title: Text(
                'No sales yet.',
                style: textTheme.body3(
                  Palette.neutral[50],
                  FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              titleAlignment: ListTileTitleAlignment.center,
            ),
          ),
        ),
        const SizedBox(height: kSpacing4),
      ],
    );
  }
}
