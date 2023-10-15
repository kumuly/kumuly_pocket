import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DynamicIcon extends StatelessWidget {
  const DynamicIcon({
    Key? key,
    required this.icon,
    this.color,
    this.size,
  }) : super(key: key);

  final dynamic icon;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return icon is IconData
        ? Icon(icon, color: color, size: size)
        : icon is ImageProvider
            ? Image(
                image: icon,
                color: color,
                width: size,
                height: size,
              )
            : icon is String
                ? SvgPicture.asset(
                    icon,
                    colorFilter: color != null
                        ? ColorFilter.mode(color!, BlendMode.srcIn)
                        : null,
                    width: size,
                    height: size,
                  )
                : icon is Widget
                    ? icon
                    : const SizedBox();
  }
}
