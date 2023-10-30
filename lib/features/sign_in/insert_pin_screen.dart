import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/services/authentication_service.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:kumuly_pocket/widgets/pin/numeric_keyboard.dart';
import 'package:kumuly_pocket/widgets/pin/pin_code_display.dart';
import 'package:kumuly_pocket/services/account_service.dart';
import 'package:kumuly_pocket/features/sign_in/sign_in_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InsertPinScreen extends ConsumerWidget {
  const InsertPinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
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

    // Todo: Extract to a common widget to insert pin and make the on-pressed settable
    // probably the controller and state should also be extracted in some common classes or it should be a stateful widget
    return Scaffold(
      appBar: AppBar(
        title: Text(
          copy.insertPIN,
          style: textTheme.display4(
            Palette.neutral[100],
            FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.white,
        iconTheme: IconThemeData(color: Palette.neutral[100]),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 35,
                  child: Text(
                    copy.insertYourPINToUnlock,
                    textAlign: TextAlign.center,
                    style: textTheme.body2(
                        Palette.neutral[100]!.withOpacity(0.3),
                        FontWeight.w400),
                  ),
                ),
                const SizedBox(height: kLargeSpacing),
                PinCodeDisplay(pinCode: pin),
                const SizedBox(height: kSmallSpacing),
                SizedBox(
                  height: 20, // Adjust this to a suitable height
                  child: pin.length == 4 && !isValidPin
                      ? RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: textTheme.body2(
                                Colors.red.withOpacity(0.7), FontWeight.w400),
                            children: <TextSpan>[
                              TextSpan(
                                text: copy.incorrectPIN,
                              ),
                            ],
                          ),
                        )
                      : Container(), // Empty container when no error
                ),
              ],
            ),
          ),
          const SizedBox(height: kExtraSmallSpacing),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: NumericKeyboard(
                onNumberSelected: signInControllerNotifier.addNumberToPin,
                onBackspace: signInControllerNotifier.removeNumberFromPin,
              ),
            ),
          ),
          const SizedBox(height: kSmallSpacing),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryFilledButton(
                text: copy.confirmPIN,
                onPressed: pin.length != 4 || !isValidPin
                    ? null
                    : () async {
                        try {
                          final signInPromise =
                              signInControllerNotifier.signIn();
                          showTransitionDialog(context, copy.oneMomentPlease);

                          await signInPromise;
                          router.goNamed('pocket');
                        } catch (e) {
                          print(e);
                          router.pop();
                        }
                      },
              ),
            ],
          ),
          const SizedBox(height: kSmallSpacing),
        ],
      ),
    );
  }
}
