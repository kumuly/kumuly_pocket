import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class PrimaryBorderButton extends StatelessWidget {
  PrimaryBorderButton({
    Key? key,
    this.leadingIcon,
    required this.text,
    this.trailingIcon,
    required this.onPressed,
    color,
    this.borderWidth = 2.0,
  })  : color = color ?? Palette.neutral[100],
        super(key: key);

  final Icon? leadingIcon;
  final String text;
  final Icon? trailingIcon;
  final VoidCallback? onPressed;
  final Color color;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
        side: BorderSide(
          color: color,
          width: borderWidth,
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leadingIcon != null) leadingIcon!,
          if (leadingIcon != null) const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.display3(
                  color,
                  FontWeight.w600,
                ),
          ),
          if (trailingIcon != null) const SizedBox(width: 8),
          if (trailingIcon != null) trailingIcon!,
        ],
      ),
    );
  }
}
