import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/providers/breez_sdk_providers.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;

    // Todo: add providers to check accounts and connection

    // Make sure the BreezSDKs are initialized for all accounts on the device
    // This way they can all keep receiving payments while the app is running
    // instead of only the connected account. (Todo: check if this is true)
    ref.read(initializeBreezSdksProvider);

    // Schedule the dialog presentation after the current build phase.
    Future.microtask(() async {
      // Show loading screen while checking for accounts and connection
      showTransitionDialog(context, copy.oneMomentPlease);

      // Todo: Remove the following delay, it is just to test the loading dialog
      await Future.delayed(const Duration(seconds: 2));

      router.pop();

      if (false) {
        router.goNamed('landing');
      } else if (false) {
        router.goNamed('sign-in');
      } else {
        router.goNamed('pocket');
      }
    });

    return Container(color: Palette.russianViolet[100]);
  }
}
