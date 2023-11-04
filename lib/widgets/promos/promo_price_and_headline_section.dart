import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class PromoPriceAndHeadlineSection extends StatelessWidget {
  const PromoPriceAndHeadlineSection(
    this.originalPrice,
    this.discountedPrice,
    this.headline, {
    Key? key,
  }) : super(key: key);

  final double originalPrice;
  final double discountedPrice;
  final String headline;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              discountedPrice.floor() == discountedPrice
                  ? discountedPrice.toStringAsFixed(0)
                  : discountedPrice.toStringAsFixed(2),
              style: textTheme.display6(
                Palette.neutral[120],
                FontWeight.w400,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              heightFactor: 1.5,
              child: Text(
                '€',
                style: textTheme.caption1(
                  Palette.neutral[120],
                  FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 4.0),
            discountedPrice == originalPrice
                ? Container()
                : Text(
                    originalPrice.floor() == originalPrice
                        ? originalPrice.toStringAsFixed(0)
                        : originalPrice.toStringAsFixed(2),
                    style: textTheme
                        .caption1(
                          Palette.neutral[40],
                          FontWeight.w400,
                        )
                        .copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
          ],
        ),
        const SizedBox(height: 4.0),
        Text(
          headline,
          style: textTheme.body4(
            Palette.neutral[80],
            FontWeight.w400,
            wordSpacing: 0,
          ),
        ),
      ],
    );
  }
}
