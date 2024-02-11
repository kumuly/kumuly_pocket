import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/router/app_router.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/services/mnemonic_service.dart';
import 'package:kumuly_pocket/services/pin_derived_encrypted_key_management_service.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:kumuly_pocket/widgets/pin/pin_controller.dart';
import 'package:kumuly_pocket/widgets/screens/pin_input_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppUnlockScreen extends ConsumerWidget {
  const AppUnlockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);

    final pinState = ref.watch(pinControllerProvider);
    final pinNotifier = ref.read(
      pinControllerProvider.notifier,
    );
    final isValidPin =
        ref.watch(checkPinProvider(pinState.pin)).asData?.value ?? false;

    return PinInputScreen(
      pin: pinState.pin,
      isValidPin: isValidPin,
      onNumberSelectHandler: pinNotifier.addNumberToPin,
      onBackspaceHandler: pinNotifier.removeNumberFromPin,
      confirmHandler: () async {
        final path = router.routeInformationProvider.value.uri.path;
        // If the path is '/appUnlock',
        //  then the user is just starting the app and everything needs to be
        //  initialized and connected.
        // Else, the user is resuming the app and this PIN screen should have
        //  been pushed on top of the stack. So we need to pop it off on a valid
        //  PIN.
        if (path == '/appUnlock') {
          showTransitionDialog(context, copy.oneMomentPlease);
          final mnemonics = await ref
              .read(masterKeyEncryptedMnemonicServiceProvider)
              .getStoredMnemonics();
          await ref.read(breezeSdkLightningNodeServiceProvider).connect(
                ref.watch(
                  bitcoinNetworkProvider,
                ),
                await ref
                    .read(masterKeyEncryptedMnemonicServiceProvider)
                    .getMnemonic(mnemonics.first, pinState.pin),
              );
          router.pop();
          router.goNamed(AppRoute.pocket.name);
        } else {
          router.pop();
        }
      },
    );
  }
}
