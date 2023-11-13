import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/promo_validation_flow/scanner/promo_validation_scanner_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/widgets/backgrounds/background_container.dart';
import 'package:kumuly_pocket/widgets/containers/focus_mark_container.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class PromoValidationScannerScreen extends ConsumerWidget {
  const PromoValidationScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          copy.promoQrScan,
          style: textTheme.display4(Colors.white, FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
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
                      copy.scanQrToRedeemPromo,
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
                        onDetect: (capture) {
                          showTransitionDialog(context, copy.oneMomentPlease);
                          try {
                            ref
                                .read(promoValidationScannerControllerProvider
                                    .notifier)
                                .handleQrCapture(capture);
                            router.pop();
                            ref
                                .read(pageViewControllerProvider(
                                        kPromoValidationFlowPageViewId)
                                    .notifier)
                                .nextPage();
                          } catch (e) {
                            print(e);
                            router.pop();
                          }
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
