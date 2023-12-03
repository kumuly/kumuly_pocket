import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class NumericKeyboard extends StatelessWidget {
  NumericKeyboard({
    Key? key,
    required this.onNumberSelected,
    required this.onBackspace,
    color,
  })  : color = color ?? Palette.russianViolet[100]!,
        super(key: key);

  final Function(String) onNumberSelected;
  final VoidCallback onBackspace;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        if (index == 9) {
          return Container();
        } else if (index == 10) {
          return NumericKeyboardButton(
            onPressed: () => onNumberSelected('0'),
            text: '0',
            color: color,
          );
        } else if (index == 11) {
          return IconKeyboardButton(
            onPressed: onBackspace,
            icon: Icon(Icons.backspace_outlined, size: 30, color: color),
          );
        } else {
          return NumericKeyboardButton(
            onPressed: () => onNumberSelected('${index + 1}'),
            text: '${index + 1}',
            color: color,
          );
        }
      },
    );
  }
}

class NumericKeyboardButton extends StatelessWidget {
  const NumericKeyboardButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.color,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 40,
      height: 40,
      color: Colors.transparent,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: textTheme.display7(
            color ?? Palette.russianViolet[100]!,
            FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class IconKeyboardButton extends StatelessWidget {
  const IconKeyboardButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      color: Colors.transparent,
      child: TextButton(
        onPressed: onPressed,
        child: icon,
      ),
    );
  }
}
