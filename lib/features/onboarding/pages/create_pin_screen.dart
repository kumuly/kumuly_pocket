import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/onboarding/onboarding_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:kumuly_pocket/widgets/screens/pin_input_screen.dart';

class OnboardingCreatePinScreen extends ConsumerWidget {
  const OnboardingCreatePinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final pageController = ref.read(
      pageViewControllerProvider(
        kOnboardingFlowPageViewId,
      ).notifier,
    );

    final notifier = ref.read(
      onboardingControllerProvider(kInviteCodeLength).notifier,
    );
    final pin = ref.watch(onboardingControllerProvider(kInviteCodeLength)).pin;

    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) => pageController.previousPage(),
      child: PinInputScreen(
        leading: BackButton(
          onPressed: pageController.previousPage,
        ),
        title: copy.createPIN,
        subtitle: copy.chooseAPIN,
        pin: pin,
        isValidPin: true,
        onNumberSelectHandler: notifier.addNumberToPin,
        onBackspaceHandler: notifier.removeNumberFromPin,
        confirmButtonText: copy.continueLabel,
        confirmHandler: pageController.nextPage,
      ),
    );
  }
}
