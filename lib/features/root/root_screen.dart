import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/enums/app_network.dart';
import 'package:kumuly_pocket/services/wallet_service.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
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
    final fetchingHasWallet = ref.read(walletServiceImplProvider).hasWallet();
    final fetchingHasPin = ref.read(walletServiceImplProvider).hasPin();

    // Schedule the dialog presentation after the current build phase.
    Future.microtask(() async {
      // Show loading screen while checking for accounts and connection
      showTransitionDialog(context, copy.oneMomentPlease);

      // Show the transition dialog for at least 1.5 seconds while checking
      // for accounts and connection.
      await Future.delayed(const Duration(milliseconds: 1500));
      final hasWallet = await fetchingHasWallet;
      final hasPin = await fetchingHasPin;

      // If no accounts exist on the device yet, go to the landing screen.
      if (!hasWallet || !hasPin) {
        router.pop();
        router.goNamed('landing-flow');
        return Container(color: Palette.russianViolet[100]);
      } else {
        // Connect the node
        await ref.read(breezeSdkLightningNodeServiceProvider).connect(
              AppNetwork.bitcoin,
            );
        router.pop();
        router.goNamed('pocket');
      }
    });

    return Container(color: Palette.lilac[100]);
  }
}
