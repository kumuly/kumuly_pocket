import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/onboarding/pin_setup_flow/pages/pin_setup_confirmation_screen.dart';
import 'package:kumuly_pocket/features/onboarding/pin_setup_flow/pages/pin_setup_creation_screen.dart';
import 'package:kumuly_pocket/features/onboarding/pin_setup_flow/pin_setup_controller.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class PinSetupFlow extends ConsumerWidget {
  const PinSetupFlow({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(
      pageViewControllerProvider(
        kPinSetupFlowPageViewId,
      ),
    );
    ref.watch(pinSetupControllerProvider);

    return PageView(
      controller: pageController.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        PinSetupCreationScreen(),
        PinSetupConfirmationScreen(),
      ],
    );
  }
}
