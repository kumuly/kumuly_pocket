import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/services/mnemonic_service.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;

    // Add providers to check for existing connection and accounts
    final gettingMnemonics = ref
        .read(masterKeyEncryptedMnemonicServiceProvider)
        .getStoredMnemonics();

    // Schedule the dialog presentation after the current build phase.
    Future.microtask(() async {
      // Show loading screen while checking for accounts and connection
      showTransitionDialog(context, copy.oneMomentPlease);

      // Show the transition dialog for at least 1.5 seconds while checking
      // for accounts and connection.
      await Future.delayed(const Duration(milliseconds: 1500));
      final mnemonics = await gettingMnemonics;

      // If no mnemonics are stored on the device yet, go to the landing screen.
      if (mnemonics.isEmpty) {
        router.pop();
        router.goNamed('onboarding');
        return Container(color: Palette.lilac[100]);
      } else {
        // Wallet was created already, so can connect to node
        // Todo: PIN is needed to unlock the wallet
        /*await ref.read(breezeSdkLightningNodeServiceProvider).connect(
              ref.watch(
                bitcoinNetworkProvider,
              ),
              await ref
                  .read(masterKeyEncryptedMnemonicServiceProvider)
                  .getMnemonic(mnemonics.first, ''),
            );
          */

        router.pop();
        router.goNamed('pocket');
        return Container(color: Palette.lilac[100]);
      }
    });

    return Container(color: Palette.lilac[100]);
  }
}
