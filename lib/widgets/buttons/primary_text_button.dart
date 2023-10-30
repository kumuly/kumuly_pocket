import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class PrimaryTextButton extends StatelessWidget {
  PrimaryTextButton({
    Key? key,
    this.leadingIcon,
    required this.text,
    this.textStyle,
    this.trailingIcon,
    required this.onPressed,
    color,
  })  : color = color ?? Palette.neutral[100],
        super(key: key);

  final Icon? leadingIcon;
  final String text;
  final TextStyle? textStyle;
  final Icon? trailingIcon;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leadingIcon != null) leadingIcon!,
          const SizedBox(width: 8),
          Text(
            text,
            style: textStyle ??
                Theme.of(context).textTheme.display3(
                      color,
                      FontWeight.w600,
                    ),
          ),
          const SizedBox(width: 8),
          if (trailingIcon != null) trailingIcon!,
        ],
      ),
    );
  }
}
