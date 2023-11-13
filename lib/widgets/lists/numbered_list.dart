import 'package:flutter/material.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class NumberedList extends StatelessWidget {
  const NumberedList({
    Key? key,
    required this.listItems,
    this.spaceBetweenItems = kSpacing1,
    this.textStyle,
    this.maxItems,
  }) : super(key: key);

  final List<String> listItems;
  final double spaceBetweenItems;
  final TextStyle? textStyle;
  final int? maxItems;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final length = maxItems == null
        ? listItems.length
        : listItems.length > maxItems!
            ? maxItems!
            : listItems.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        length,
        (index) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index + 1}.',
                  style: textTheme.body3(
                    Palette.neutral[70],
                    FontWeight.w400,
                    wordSpacing: 0,
                  ),
                ),
                const SizedBox(width: 4.0),
                Flexible(
                  child: Text(
                    listItems[index],
                    style: textTheme.body3(
                      Palette.neutral[70],
                      FontWeight.w400,
                      wordSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
            if (index != length - 1) SizedBox(height: spaceBetweenItems),
          ],
        ),
        growable: false,
      ),
    );
  }
}
