import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/services/account_service.dart';
import 'package:kumuly_pocket/services/authentication_service.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:kumuly_pocket/features/sign_up/sign_up_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/screens/pin_input_screen.dart';

class ConfirmPinScreen extends ConsumerWidget {
  const ConfirmPinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;
    final signUpController = signUpControllerProvider(
      ref.watch(firebaseAuthenticationServiceProvider),
      ref.watch(sharedPreferencesAccountServiceProvider),
      ref.watch(breezeSdkLightningNodeServiceProvider),
    );
    final signUpControllerNotifier = ref.read(
      signUpController.notifier,
    );
    final pinConfirmation = ref.watch(signUpController).pinConfirmation;
    final pin = ref.watch(signUpController).pin;
    final mnemonicWords = ref.watch(signUpController).mnemonicWords;

    return PinInputScreen(
      title: copy.confirmPIN,
      subtitle: copy.confirmPINDescription,
      pin: pinConfirmation,
      isValidPin: pin == pinConfirmation,
      errorMessage: copy.pinDoesNotMatch,
      onNumberSelectHandler:
          signUpControllerNotifier.addNumberToPinConfirmation,
      onBackspaceHandler:
          signUpControllerNotifier.removeNumberFromPinConfirmation,
      confirmButtonText: copy.confirmPIN,
      confirmHandler: () async {
        showTransitionDialog(context, copy.oneMomentPlease);
        try {
          if (mnemonicWords.isEmpty) {
            // Only generate a mnemonic if it hasn't been generated yet.
            signUpControllerNotifier.generateMnemonic();
          }
          await signUpControllerNotifier.setupLightningNode();
          await signUpControllerNotifier.saveNewAccount();
          await signUpControllerNotifier.logIn();
          router.goNamed('pocket');
        } catch (e) {
          print(e);
          try {
            // Disconnect node here
            await signUpControllerNotifier.disconnectNode();
          } catch (e) {
            print(e);
          }
          router.pop();
        }
      },
    );
  }
}
