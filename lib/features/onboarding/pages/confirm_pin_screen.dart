import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:kumuly_pocket/features/onboarding/onboarding_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:kumuly_pocket/widgets/screens/pin_input_screen.dart';

class OnboardingConfirmPinScreen extends ConsumerWidget {
  const OnboardingConfirmPinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;
    final pageController = ref.read(
      pageViewControllerProvider(
        kOnboardingFlowPageViewId,
      ).notifier,
    );

    final state = ref.watch(onboardingControllerProvider(kInviteCodeLength));
    final notifier = ref.read(
      onboardingControllerProvider(kInviteCodeLength).notifier,
    );
    final pinConfirmation = state.pinConfirmation;
    final pin = state.pin;

    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) => pageController.previousPage(),
      child: PinInputScreen(
        leading: BackButton(
          onPressed: pageController.previousPage,
        ),
        title: copy.confirmPIN,
        subtitle: copy.confirmPINDescription,
        pin: pinConfirmation,
        isValidPin: pin == pinConfirmation,
        errorMessage: copy.pinDoesNotMatch,
        onNumberSelectHandler: notifier.addNumberToPinConfirmation,
        onBackspaceHandler: notifier.removeNumberFromPinConfirmation,
        confirmButtonText: copy.confirmPIN,
        confirmHandler: () async {
          try {
            final settingUp = notifier.setup();
            showTransitionDialog(context, copy.oneMomentPlease);
            await settingUp;
            router.pop();
            router.goNamed('pocket');
          } catch (e) {
            if (e is CouldNotConnectToNodeException) {
              pageController.jumpToPage(0);
            }
            router.pop();
          }
        },
      ),
    );
  }
}
