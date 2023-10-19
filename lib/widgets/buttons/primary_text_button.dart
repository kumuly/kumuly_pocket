import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class PrimaryTextButton extends StatelessWidget {
  PrimaryTextButton({
    Key? key,
    this.leadingIcon,
    required this.text,
    this.trailingIcon,
    required this.onPressed,
    this.width = double.infinity,
    color,
  })  : color = color ?? Palette.neutral[100],
        super(key: key);

  final Icon? leadingIcon;
  final String text;
  final Icon? trailingIcon;
  final VoidCallback? onPressed;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextButton(
        style: TextButton.styleFrom(
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
                    color,
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
