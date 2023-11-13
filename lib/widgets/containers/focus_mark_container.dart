import 'dart:math';

import 'package:flutter/material.dart';

class FocusMarkContainer extends StatelessWidget {
  const FocusMarkContainer({
    super.key,
    required this.height,
    required this.width,
    required this.child,
    this.focusCornerLength = 15.0,
    this.focusRadius = 12.0,
    this.focusColor = Colors.white,
    this.focusStrokeWidth = 3.0,
  });

  final double height;
  final double width;
  final Widget child;
  final double focusCornerLength;
  final double focusRadius;
  final Color focusColor;
  final double focusStrokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Camera focus
          CustomPaint(
            size: Size(height, width),
            painter: FocusMarkPainter(
              color: focusColor,
              arcSize: focusRadius,
              cornerSize: focusCornerLength,
              strokeWidth: focusStrokeWidth,
            ),
          ),

          child,
        ],
      ),
    );
  }
}

class FocusMarkPainter extends CustomPainter {
  final Color color;
  final double arcSize; // radius of the corner arcs
  final double cornerSize; // length of the corner lines
  final double strokeWidth;

  FocusMarkPainter({
    this.color = Colors.white,
    this.arcSize = 12.0,
    this.cornerSize = 15.0,
    this.strokeWidth = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round; // This gives a rounded end to the lines.

    double width = size.width;
    double height = size.height;

    // Top-left corner
    canvas.drawArc(const Offset(0, 0) & Size(arcSize * 2, arcSize * 2), pi,
        pi / 2, false, paint);
    canvas.drawLine(Offset(arcSize, 0), Offset(cornerSize, 0), paint);
    canvas.drawLine(Offset(0, arcSize), Offset(0, cornerSize), paint);

    // Top-right corner
    canvas.drawArc(
        Offset(width - arcSize * 2, 0) & Size(arcSize * 2, arcSize * 2),
        -pi / 2,
        pi / 2,
        false,
        paint);
    canvas.drawLine(
        Offset(width - arcSize, 0), Offset(width - cornerSize, 0), paint);
    canvas.drawLine(Offset(width, arcSize), Offset(width, cornerSize), paint);

    // Bottom-left corner
    canvas.drawArc(
        Offset(0, height - arcSize * 2) & Size(arcSize * 2, arcSize * 2),
        pi / 2,
        pi / 2,
        false,
        paint);
    canvas.drawLine(Offset(arcSize, height), Offset(cornerSize, height), paint);
    canvas.drawLine(
        Offset(0, height - arcSize), Offset(0, height - cornerSize), paint);

    // Bottom-right corner
    canvas.drawArc(
        Offset(width - arcSize * 2, height - arcSize * 2) &
            Size(arcSize * 2, arcSize * 2),
        0,
        pi / 2,
        false,
        paint);
    canvas.drawLine(Offset(width - arcSize, height),
        Offset(width - cornerSize, height), paint);
    canvas.drawLine(Offset(width, height - arcSize),
        Offset(width, height - cornerSize), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
