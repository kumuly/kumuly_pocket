import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class DrawerSectionTitle extends StatelessWidget {
  const DrawerSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      titleTextStyle: Theme.of(context).textTheme.display1(
            Palette.neutral[60],
            FontWeight.w500,
          ),
    );
  }
}
