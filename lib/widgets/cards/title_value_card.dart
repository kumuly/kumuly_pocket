import 'package:flutter/material.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class TitleValueCard extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final String? value;
  final Widget? valueWidget;
  final String? extraInfo;
  final String? trailingImageName;
  final Widget? leadingWidget;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final TextStyle? extraInfoStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? actionButton;
  final BorderRadiusGeometry? borderRadius;
  final BoxShadow? boxShadow;

  const TitleValueCard({
    super.key,
    this.backgroundColor = Colors.white,
    required this.title,
    this.value,
    this.valueWidget,
    this.extraInfo,
    this.trailingImageName,
    this.leadingWidget,
    this.titleStyle,
    this.valueStyle,
    this.extraInfoStyle,
    this.padding,
    this.margin,
    this.actionButton,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: backgroundColor,
      margin: margin ?? const EdgeInsets.all(8.0),
      elevation: boxShadow != null ? 1.0 : 0.0,
      shadowColor: boxShadow?.color ?? Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        side: BorderSide(
          color: boxShadow?.color ?? Colors.transparent,
          width: boxShadow != null ? 1.0 : 0.0,
        ),
      ),
      child: Padding(
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          children: [
            Row(
              children: [
                if (leadingWidget != null) leadingWidget!,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: titleStyle ??
                            textTheme.display2(
                                Palette.neutral[60], FontWeight.w600),
                      ),
                      const SizedBox(height: kSpacing2),
                      valueWidget ??
                          Text(
                            value ?? '',
                            style: valueStyle ??
                                textTheme.display1(
                                    Palette.neutral[80], FontWeight.w500),
                          ),
                      if (extraInfo != null) const SizedBox(height: kSpacing2),
                      if (extraInfo != null)
                        Text(
                          extraInfo!,
                          style: extraInfoStyle ??
                              textTheme.display1(
                                  Palette.neutral[50], FontWeight.w500),
                        ),
                    ],
                  ),
                ),
                if (trailingImageName != null)
                  Image.asset(
                    trailingImageName!,
                    height: 32.0,
                    width: 32.0,
                  ),
              ],
            ),
            if (actionButton != null) actionButton!,
          ],
        ),
      ),
    );
  }
}
