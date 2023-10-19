import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class PrimaryFilledButton extends StatelessWidget {
  PrimaryFilledButton({
    Key? key,
    this.leadingIcon,
    required this.text,
    this.trailingIcon,
    required this.onPressed,
    this.width = double.infinity,
    fillColor,
    textColor,
  })  : fillColor = fillColor ?? Palette.neutral[100]!,
        textColor = textColor ?? Colors.white,
        super(key: key);

  final Icon? leadingIcon;
  final String text;
  final Icon? trailingIcon;
  final VoidCallback? onPressed;
  final double width;
  final Color fillColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: FilledButton(
        style: FilledButton.styleFrom(
          fixedSize: Size(width, 48),
          backgroundColor: fillColor,
          disabledBackgroundColor: fillColor.withOpacity(0.1),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) leadingIcon!,
            const SizedBox(width: 8),
            Text(
              text,
              style: Theme.of(context).textTheme.display3(
                    textColor,
                    FontWeight.w600,
                  ),
            ),
            const SizedBox(width: 8),
            if (trailingIcon != null) trailingIcon!,
          ],
        ),
      ),
    );
  }
}
