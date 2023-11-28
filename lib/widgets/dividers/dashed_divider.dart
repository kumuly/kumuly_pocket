import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class DashedDivider extends StatelessWidget {
  const DashedDivider({
    this.color,
    this.thickness = 1,
    this.dashLength = 2,
    this.dashSpace = 4,
    this.length,
    Key? key,
  }) : super(key: key);

  final Color? color;
  final double thickness;
  final double dashLength;
  final double dashSpace;
  final double? length;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DrawDottedhorizontalline(
        color: color ?? Palette.neutral[40]!,
        thickness: thickness,
        dashLength: dashLength,
        dashSpace: dashSpace,
        length: length,
      ),
      size: Size(length ?? double.infinity, thickness),
    );
  }
}

class DrawDottedhorizontalline extends CustomPainter {
  final Paint _paint;
  final double dashLength;
  final double dashSpace;
  final double? length;

  DrawDottedhorizontalline({
    required Color color,
    required double thickness,
    required this.dashLength,
    required this.dashSpace,
    this.length,
  }) : _paint = Paint()
          ..color = color
          ..strokeWidth = thickness
          ..strokeCap = StrokeCap.square;

  @override
  void paint(Canvas canvas, Size size) {
    double startX = 0;
    double endX = length ?? size.width;

    for (double i = startX; i < endX; i += dashLength + dashSpace) {
      canvas.drawLine(Offset(i, 0.0), Offset(i + dashLength, 0.0), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
