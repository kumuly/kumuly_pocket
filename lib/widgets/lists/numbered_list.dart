import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class NumberedList extends StatelessWidget {
  const NumberedList({
    Key? key,
    required this.listItems,
    this.spaceBetweenItems = 8.0,
    this.textStyle,
  }) : super(key: key);

  final List<String> listItems;
  final double spaceBetweenItems;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        listItems.length,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: spaceBetweenItems),
          child: Row(
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
              Expanded(
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
        ),
      ),
    );
  }
}
