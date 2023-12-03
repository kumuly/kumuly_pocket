import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/services/authentication_service.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:kumuly_pocket/services/account_service.dart';
import 'package:kumuly_pocket/features/sign_in/sign_in_controller.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/screens/pin_screen.dart';

class InsertPinScreen extends ConsumerWidget {
  const InsertPinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;
    final signInController = signInControllerProvider(
      ref.watch(firebaseAuthenticationServiceProvider),
      ref.watch(sharedPreferencesAccountServiceProvider),
      ref.watch(breezeSdkLightningNodeServiceProvider),
    );
    final signInControllerNotifier = ref.read(
      signInController.notifier,
    );
    final nodeId = ref.watch(signInController).selectedAccount.nodeId;
    final pin = ref.watch(signInController).pin;
    final isValidPin =
        ref.watch(checkPinProvider(nodeId, pin)).asData?.value ?? false;

    return PinScreen(
      pin: pin,
      isValidPin: isValidPin,
      onNumberSelectHandler: signInControllerNotifier.addNumberToPin,
      onBackspaceHandler: signInControllerNotifier.removeNumberFromPin,
      confirmHandler: () async {
        try {
          final signInPromise = signInControllerNotifier.signIn();
          showTransitionDialog(context, copy.oneMomentPlease);

          await signInPromise;
          router.goNamed('pocket');
        } catch (e) {
          print(e);
          router.pop();
        }
      },
    );
  }
}
