import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class NumericKeyboard extends StatelessWidget {
  NumericKeyboard({
    Key? key,
    required this.onNumberSelected,
    required this.onBackspace,
    color,
  })  : color = color ?? Palette.neutral[100]!,
        super(key: key);

  final Function(String) onNumberSelected;
  final VoidCallback onBackspace;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        if (index == 9) {
          return const SizedBox.shrink();
        } else if (index == 10) {
          return GestureDetector(
            onTap: () => onNumberSelected('0'),
            child: Center(
              child: Text('0', style: TextStyle(color: color)),
            ),
          );
        } else if (index == 11) {
          return GestureDetector(
            onTap: onBackspace,
            child: Center(
              child: Icon(Icons.backspace_outlined, size: 20, color: color),
            ),
          );
        } else {
          return GestureDetector(
            onTap: () => onNumberSelected('${index + 1}'),
            child: Center(
              child: Text("${index + 1}", style: TextStyle(color: color)),
            ),
          );
        }
      },
    );
  }
}
