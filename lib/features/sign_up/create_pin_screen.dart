import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/services/account_service.dart';
import 'package:kumuly_pocket/services/authentication_service.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/features/sign_up/sign_up_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/screens/pin_input_screen.dart';

class CreatePinScreen extends ConsumerWidget {
  const CreatePinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final signUpController = signUpControllerProvider(
      ref.watch(firebaseAuthenticationServiceProvider),
      ref.watch(sharedPreferencesAccountServiceProvider),
      ref.watch(breezeSdkLightningNodeServiceProvider),
    );
    final signUpControllerNotifier = ref.read(
      signUpController.notifier,
    );
    final pin = ref.watch(signUpController).pin;

    return PinInputScreen(
      title: copy.createPIN,
      subtitle: copy.chooseAPIN,
      pin: pin,
      isValidPin: true,
      onNumberSelectHandler: signUpControllerNotifier.addNumberToPin,
      onBackspaceHandler: signUpControllerNotifier.removeNumberFromPin,
      confirmButtonText: copy.continueLabel,
      confirmHandler: () => context.pushNamed('confirm-pin'),
    );
  }
}
