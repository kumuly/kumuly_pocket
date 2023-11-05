import 'package:flutter/material.dart';

class RippedPaperClipper extends CustomClipper<Path> {
  final int numberOfRips;
  final double ripHeight;

  RippedPaperClipper({this.numberOfRips = 22, this.ripHeight = 5.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    final step = size.width / numberOfRips;

    for (int i = 0; i < numberOfRips; i++) {
      path.lineTo(i * step, size.height);
      path.lineTo((i + 0.5) * step, size.height - ripHeight);
      path.lineTo((i + 1) * step, size.height);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
