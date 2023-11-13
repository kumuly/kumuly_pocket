import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/features/promo_validation_flow/completed/promo_validation_cancelled_screen.dart';
import 'package:kumuly_pocket/features/promo_validation_flow/completed/promo_validation_validated_screen.dart';
import 'package:kumuly_pocket/features/promo_validation_flow/redemption/promo_validation_redemption_controller.dart';

class PromoValidationCompletedScreen extends ConsumerWidget {
  const PromoValidationCompletedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isValidated =
        ref.watch(promoValidationRedemptionControllerProvider).isValidated;
    final isCancelled =
        ref.watch(promoValidationRedemptionControllerProvider).isCancelled;

    if (isValidated) {
      return const PromoValidationValidatedScreen();
    }
    return const PromoValidationCancelledScreen();
  }
}
