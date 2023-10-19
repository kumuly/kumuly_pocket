import 'package:flutter/material.dart';
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
    this.pinRadius = 5.0,
  })  : completedPinColor = completedPinColor ?? Palette.neutral[100]!,
        incompletePinColor = incompletePinColor ?? Palette.neutral[50]!,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pinCodeLength, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: CircleAvatar(
            backgroundColor:
                index < pinCode.length ? completedPinColor : incompletePinColor,
            radius: pinRadius,
          ),
        );
      }),
    );
  }
}
