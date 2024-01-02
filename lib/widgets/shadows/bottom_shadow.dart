import 'package:flutter/material.dart';

class BottomShadow extends StatelessWidget {
  const BottomShadow({
    super.key,
    this.spreadRadius = 30,
    this.blurRadius = 40,
    required this.width,
    this.color = Colors.white,
  });

  final double spreadRadius;
  final double blurRadius;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        height: 1,
        width: width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: color,
              offset: const Offset(0, -10),
              spreadRadius: spreadRadius,
              blurRadius: blurRadius,
            ),
          ],
        ),
      ),
    );
  }
}
