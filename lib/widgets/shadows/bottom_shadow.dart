import 'package:flutter/material.dart';

class BottomShadow extends StatelessWidget {
  const BottomShadow({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        height: 1,
        width: width,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              offset: Offset(0, -10),
              spreadRadius: 30,
              blurRadius: 40,
            ),
          ],
        ),
      ),
    );
  }
}
