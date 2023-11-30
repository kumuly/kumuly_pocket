import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';

class RectangularBorderButton extends StatelessWidget {
  RectangularBorderButton({
    Key? key,
    this.leadingIcon,
    required this.text,
    this.trailingIcon,
    required this.onPressed,
    this.width = double.infinity,
    this.fillColor = Colors.white,
    textColor,
    disabledTextColor,
    borderColor,
    this.borderWidth = 1.0,
  })  : textColor = textColor ?? Palette.russianViolet[100],
        disabledTextColor = disabledTextColor ?? Palette.neutral[40]!,
        borderColor = borderColor ?? Palette.neutral[30]!,
        super(key: key);

  final DynamicIcon? leadingIcon;
  final String text;
  final DynamicIcon? trailingIcon;
  final VoidCallback? onPressed;
  final double width;
  final Color fillColor;
  final Color textColor;
  final Color disabledTextColor;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white, // Filled color
        border: Border(
          top: BorderSide(width: borderWidth, color: borderColor), // Top border
          bottom: BorderSide(
              width: borderWidth, color: borderColor), // Bottom border
        ),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          disabledIconColor: disabledTextColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          fixedSize: Size(width, 48),
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
                    onPressed == null ? disabledTextColor : textColor,
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
