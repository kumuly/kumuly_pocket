import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/features/onboarding/pin_setup_flow/pin_setup_controller.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:kumuly_pocket/widgets/screens/pin_input_screen.dart';

class PinSetupCreationScreen extends ConsumerWidget {
  const PinSetupCreationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final pageController = ref.read(
      pageViewControllerProvider(
        kPinSetupFlowPageViewId,
      ).notifier,
    );

    final notifier = ref.read(
      pinSetupControllerProvider.notifier,
    );
    final pin = ref.watch(pinSetupControllerProvider).pin;

    return PinInputScreen(
      title: copy.createPIN,
      subtitle: copy.chooseAPIN,
      pin: pin,
      isValidPin: true,
      onNumberSelectHandler: notifier.addNumberToPin,
      onBackspaceHandler: notifier.removeNumberFromPin,
      confirmButtonText: copy.continueLabel,
      confirmHandler: pageController.nextPage,
    );
  }
}
