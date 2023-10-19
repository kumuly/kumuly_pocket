import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/providers/breez_sdk_providers.dart';
import 'package:kumuly_pocket/services/account_service.dart';
import 'package:kumuly_pocket/services/authentication_service.dart';
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
    final connectedAccount = ref.watch(connectedAccountProvider);
    final savedAccounts = ref.watch(accountsProvider);

    // Make sure the BreezSDKs are initialized for all accounts on the device
    // This way they can all keep receiving payments while the app is running
    // instead of only the connected account. (Todo: check if this is true)
    ref.read(initializeBreezSdksProvider);

    // Schedule the dialog presentation after the current build phase.
    Future.microtask(() async {
      // Show loading screen while checking for accounts and connection
      showTransitionDialog(context, copy.oneMomentPlease);

      // Todo: Remove the following delay, it is just to test the loading dialog
      await Future.delayed(const Duration(milliseconds: 1500));

      // If no accounts exist on the device yet, go to the landing screen.
      if (savedAccounts.isEmpty) {
        router.pop();
        router.goNamed('landing');
      }

      // If accounts exist, check if one is still connected.
      if (connectedAccount.hasError) {
        router.pop();
        // Todo: Show error dialog or return a widget with error message and instructions
        // to try again later.
        return Container(
            color: Palette.error[100],
            child: Text(connectedAccount.error.toString()));
      }

      if (!connectedAccount.isLoading) {
        // No error and not loading,
        //  so we have readable data and can check for a connected account
        final isAccountConnected = connectedAccount.asData?.value != null
            ? connectedAccount.value!.isNotEmpty
            : false;

        router.pop();
        if (isAccountConnected) {
          router.goNamed('pocket');
        } else {
          router.goNamed('sign-in');
        }
      }
    });

    return Container(color: Palette.russianViolet[100]);
  }
}
