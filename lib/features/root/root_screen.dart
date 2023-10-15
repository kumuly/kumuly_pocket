import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Todo: add providers to check accounts and connection
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;

    // Schedule the dialog presentation after the current build phase.
    Future.microtask(() async {
      // Show loading screen while checking for accounts and connection
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation1, animation2) {
          return TransitionDialog(
            caption: copy.oneMomentPlease,
          );
        },
      );

      // Todo: Remove the following delay, it is just to test the loading dialog
      await Future.delayed(const Duration(seconds: 5));

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
