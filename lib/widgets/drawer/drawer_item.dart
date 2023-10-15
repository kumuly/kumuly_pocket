import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    this.backgroundColor,
    this.leadingIcon,
    required this.title,
    this.titleTextStyle,
    this.subtitle,
    this.subtitleTextStyle,
    this.trailingIcon,
    this.onTap,
  });

  final Color? backgroundColor;
  final DynamicIcon? leadingIcon;
  final String title;
  final TextStyle? titleTextStyle;
  final String? subtitle;
  final TextStyle? subtitleTextStyle;
  final DynamicIcon? trailingIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: subtitle == null
          ? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)
          : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      tileColor: backgroundColor ?? Colors.transparent,
      leading: leadingIcon,
      title: Text(title),
      titleTextStyle: titleTextStyle ??
          Theme.of(context)
              .textTheme
              .display2(Palette.neutral[80], FontWeight.w600),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      subtitleTextStyle: subtitleTextStyle ??
          Theme.of(context)
              .textTheme
              .caption1(
                Palette.neutral[60],
                FontWeight.w500,
              )
              .copyWith(wordSpacing: 1.0),
      onTap: onTap,
      trailing: trailingIcon ??
          DynamicIcon(
            icon: Icons.arrow_forward_ios_outlined,
            color: Palette.neutral[80],
            size: 16,
          ),
    );
  }
}
