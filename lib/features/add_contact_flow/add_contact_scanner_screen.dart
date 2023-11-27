import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/features/add_contact_flow/add_contact_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:kumuly_pocket/widgets/screens/scanner_screen.dart';

class AddContactScannerScreen extends ConsumerWidget {
  const AddContactScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);

    final state = ref.watch(addContactControllerProvider);

    return ScannerScreen(
        appBar: AppBar(
          title: Text(
            copy.scanContactId,
            style: textTheme.display4(Colors.white, FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: router.pop,
            ),
          ],
        ),
        instructions: copy.addContactQrScanInstructions,
        captureHandler: (capture) async {
          showTransitionDialog(context, copy.oneMomentPlease);
          try {
            // Todo: move setting the text and trigger the destination change handler to the controller
            state.idTextController.text = capture;
            await ref
                .read(addContactControllerProvider.notifier)
                .onIdChangeHandler(capture);
            router.pop(); // pop the transition dialog
            router.pop(); // pop the scanner screen
          } catch (e) {
            print(e);
            router.pop(); // pop the transition dialog
            router.pop(); // pop the scanner screen
            // Todo: set error state
          }
        });
  }
}
