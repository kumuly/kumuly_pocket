import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class DashedDivider extends StatelessWidget {
  DashedDivider({
    color,
    this.thickness = 1,
    this.dashLength = 2,
    this.dashSpace = 2,
    this.length,
    Key? key,
  })  : color = color ?? Palette.neutral[40]!,
        super(key: key);

  final Color color;
  final double thickness;
  final double dashLength;
  final double dashSpace;
  final double? length;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DrawDottedhorizontalline(
        color: color,
        thickness: thickness,
        dashLength: dashLength,
        dashSpace: dashSpace,
        length: length,
      ),
    );
  }
}

class DrawDottedhorizontalline extends CustomPainter {
  late Paint _paint;
  final double dashLength;
  final double dashSpace;
  final double? length;

  DrawDottedhorizontalline({
    required Color color,
    required double thickness,
    required this.dashLength,
    required this.dashSpace,
    this.length,
  }) {
    _paint = Paint();
    _paint.color = color; //dots color
    _paint.strokeWidth = thickness; //dots thickness
    _paint.strokeCap = StrokeCap.square; //dots corner edges
  }

  @override
  void paint(Canvas canvas, Size size) {
    final startX = length == null
        ? canvas.getLocalClipBounds().center.dx
        : 0 - length! / 2;
    final endX = length == null
        ? canvas.getLocalClipBounds().center.dx.abs()
        : startX + length!;

    for (double i = startX; i < endX; i = i + dashSpace) {
      // 15 is space between dots
      if (i % 3 == 0) {
        canvas.drawLine(Offset(i, 0.0), Offset(i + dashLength, 0.0), _paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
