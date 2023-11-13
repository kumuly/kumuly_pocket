// All pages of the promo are shown here
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/promo_validation_flow/completed/promo_validation_completed_screen.dart';
import 'package:kumuly_pocket/features/promo_validation_flow/redemption/promo_validation_redemption_controller.dart';
import 'package:kumuly_pocket/features/promo_validation_flow/redemption/promo_validation_redemption_screen.dart';
import 'package:kumuly_pocket/features/promo_validation_flow/scanner/promo_validation_scanner_controller.dart';
import 'package:kumuly_pocket/features/promo_validation_flow/scanner/promo_validation_scanner_screen.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class PromoValidationFlow extends ConsumerWidget {
  const PromoValidationFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(pageViewControllerProvider(
      kPromoValidationFlowPageViewId,
    ));
    ref.watch(promoValidationScannerControllerProvider);
    ref.watch(promoValidationRedemptionControllerProvider);

    return PageView(
      controller: pageController.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        PromoValidationScannerScreen(),
        PromoValidationRedemptionScreen(),
        PromoValidationCompletedScreen(),
      ],
    );
  }
}
