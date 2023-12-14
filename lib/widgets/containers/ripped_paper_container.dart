import 'package:flutter/material.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/widgets/clippers/ripped_paper_clipper.dart';

class RippedPaperContainer extends StatelessWidget {
  const RippedPaperContainer({
    super.key,
    this.height,
    this.width,
    this.topBorderRadius = 24.0,
    this.padding = const EdgeInsets.all(kSpacing4),
    this.child,
  });

  final double? height;
  final double? width;
  final double topBorderRadius;
  final EdgeInsetsGeometry padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 24),
            spreadRadius: -12,
            blurRadius: 48,
            color: Color.fromRGBO(154, 170, 207, 0.55),
          ),
        ],
      ),
      child: ClipPath(
        clipper: RippedPaperClipper(),
        child: Container(
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topBorderRadius),
              topRight: Radius.circular(topBorderRadius),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
