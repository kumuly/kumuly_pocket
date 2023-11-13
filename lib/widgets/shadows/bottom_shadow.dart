import 'package:flutter/material.dart';

class BottomShadow extends StatelessWidget {
  const BottomShadow({super.key, this.spreadRadius = 30, required this.width});

  final double spreadRadius;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        height: 1,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              offset: const Offset(0, -10),
              spreadRadius: spreadRadius,
              blurRadius: 40,
            ),
          ],
        ),
      ),
    );
  }
}
