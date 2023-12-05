import 'package:flutter/material.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class ChipTab extends StatelessWidget {
  ChipTab({
    required this.label,
    this.isSelected = false,
    this.selectedLabelColor = Colors.white,
    unselectedLabelColor,
    selectedBackgroundColor,
    this.unselectedBackgroundColor = Colors.white,
    required this.onPressed,
    Key? key,
  })  : unselectedLabelColor = unselectedLabelColor ?? Palette.neutral[80]!,
        selectedBackgroundColor =
            selectedBackgroundColor ?? Palette.neutral[100]!,
        super(key: key);

  final String label;
  final bool isSelected;
  final Color selectedLabelColor;
  final Color unselectedLabelColor;
  final Color selectedBackgroundColor;
  final Color unselectedBackgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ActionChip(
      label: Text(
        label,
      ),
      labelStyle: textTheme.display1(
        isSelected ? Colors.white : Palette.neutral[80],
        FontWeight.w400,
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: kSpacing1 * 2),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: isSelected ? Palette.neutral[100] : Colors.white,
      elevation: 0,
      onPressed: onPressed,
    );
  }
}
