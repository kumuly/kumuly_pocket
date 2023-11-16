import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class RadioButton extends StatelessWidget {
  final bool isSelected;
  const RadioButton({Key? key, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isSelected ? Palette.lilac[100]! : Palette.neutral[60]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ZoomIn(
          duration: const Duration(milliseconds: 300),
          animate: isSelected,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Palette.lilac[100] : Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ),
    );
  }
}
