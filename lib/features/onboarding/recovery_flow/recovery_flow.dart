import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/onboarding/onboarding_controller.dart';
import 'package:kumuly_pocket/features/onboarding/recovery_flow/pages/recovery_pin_setup_confirmation_screen.dart';
import 'package:kumuly_pocket/features/onboarding/recovery_flow/pages/recovery_pin_setup_creation_screen.dart';
import 'package:kumuly_pocket/features/onboarding/recovery_flow/pages/recovery_input_screen.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class RecoveryFlow extends ConsumerWidget {
  const RecoveryFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(pageViewControllerProvider(
      kRecoveryFlowPageViewId,
    ));
    ref.watch(onboardingControllerProvider);

    return PageView(
      controller: pageController.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        RecoveryInputScreen(),
        RecoveryPinSetupCreationScreen(),
        RecoveryPinSetupConfirmationScreen(),
      ],
    );
  }
}
