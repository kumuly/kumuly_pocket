import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/features/send_sats_flow/send_sats_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:kumuly_pocket/widgets/screens/scanner_screen.dart';

class SendSatsScannerScreen extends ConsumerWidget {
  const SendSatsScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);

    final state = ref.watch(sendSatsControllerProvider);

    return ScannerScreen(
        appBar: AppBar(
          title: Text(
            copy.scanToSend,
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
        instructions: copy.sendSatsQrScanInstructions,
        captureHandler: (capture) async {
          showTransitionDialog(context, copy.oneMomentPlease);
          try {
            // Todo: move setting the text and trigger the destination change handler to the controller
            state.destinationTextController.text = capture;
            await ref
                .read(sendSatsControllerProvider.notifier)
                .onDestinationChangeHandler(capture);
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
