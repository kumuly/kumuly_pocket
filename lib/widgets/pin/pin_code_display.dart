import 'package:flutter/material.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/palette.dart';

class PinCodeDisplay extends StatelessWidget {
  final String pinCode;
  final int pinCodeLength;

  // Colors
  final Color? completedPinColor;
  final Color? incompletePinColor;

  // Radius
  final double? pinRadius;

  PinCodeDisplay({
    Key? key,
    this.pinCode = "",
    this.pinCodeLength = 4,
    completedPinColor,
    incompletePinColor,
    this.pinRadius = 6,
  })  : completedPinColor = completedPinColor ?? Palette.russianViolet[100]!,
        incompletePinColor = incompletePinColor ?? Palette.blueViolet[25]!,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        pinCodeLength,
        (index) {
          return CircleAvatar(
            backgroundColor:
                index < pinCode.length ? completedPinColor : incompletePinColor,
            radius: pinRadius,
          );
        },
      ),
    );
  }
}
