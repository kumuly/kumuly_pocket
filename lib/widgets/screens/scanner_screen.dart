import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/widgets/backgrounds/background_container.dart';
import 'package:kumuly_pocket/widgets/containers/focus_mark_container.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({
    super.key,
    this.appBar,
    required this.instructions,
    required this.captureHandler,
  });

  final AppBar? appBar;
  final String instructions;
  final Future<void> Function(String data) captureHandler;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: true,
      body: BackgroundContainer(
        appBarHeight: 0,
        assetName: 'assets/backgrounds/phone_background.png',
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              alignment: Alignment.center,
              color: Colors.black.withOpacity(0.6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kSpacing10),
                    child: Text(
                      instructions,
                      style: textTheme.display2(
                        Colors.white,
                        FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: kSpacing3),
                  FocusMarkContainer(
                    height: 235,
                    width: 235,
                    focusStrokeWidth: 2,
                    focusCornerLength: 20,
                    focusColor: Colors.white.withOpacity(0.6),
                    child: Container(
                      height: 217,
                      width: 217,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: MobileScanner(
                        controller: MobileScannerController(
                          detectionSpeed: DetectionSpeed.noDuplicates,
                        ),
                        onDetect: (dynamic capture) {
                          final data = capture.barcodes.first.rawValue;
                          captureHandler(data);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: kSpacing10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
