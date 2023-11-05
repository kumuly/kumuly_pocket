import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.starSize = 16.0,
    this.starBorder = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final double rating;
  final double starSize;
  final bool starBorder;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: List.generate(
        5,
        (index) => Icon(
          index < rating.floor() || !starBorder
              ? Icons.star
              : Icons.star_border,
          color: index < rating.floor()
              ? Palette.warning[40]
              : Palette.neutral[40],
          size: starSize,
        ),
      ),
    );
  }
}
