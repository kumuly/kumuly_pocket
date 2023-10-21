import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/services/account_service.dart';
import 'package:kumuly_pocket/services/authentication_service.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:kumuly_pocket/widgets/pin/numeric_keyboard.dart';
import 'package:kumuly_pocket/widgets/pin/pin_code_display.dart';
import 'package:kumuly_pocket/features/sign_up/sign_up_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmPinScreen extends ConsumerWidget {
  const ConfirmPinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final authService = ref.watch(firebaseAuthenticationServiceProvider);
    final accountService = ref.watch(sharedPreferencesAccountServiceProvider);
    final lightningNodeService =
        ref.watch(breezeSdkLightningNodeServiceProvider);
    final signUpControllerNotifier = ref.read(
      signUpControllerProvider(
        authService,
        accountService,
        lightningNodeService,
      ).notifier,
    );
    final signUpController = ref.watch(signUpControllerProvider(
      authService,
      accountService,
      lightningNodeService,
    ));
    final pinConfirmation = signUpController.pinConfirmation;
    final pin = signUpController.pin;
    final mnemonicWords = signUpController.mnemonicWords;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          copy.confirmPIN,
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
                  child: RichText(
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: textTheme.body2(
                          Palette.neutral[100]!.withOpacity(0.3),
                          FontWeight.w400),
                      children: <TextSpan>[
                        TextSpan(
                          text: copy.confirmPINDescription,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: kLargeSpacing),
                PinCodeDisplay(pinCode: pinConfirmation),
                const SizedBox(height: kExtraSmallSpacing),
                SizedBox(
                  height: 20, // Adjust this to a suitable height
                  child: pinConfirmation.length == 4 && pin != pinConfirmation
                      ? RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: textTheme.body2(
                                Colors.red.withOpacity(0.7), FontWeight.w400),
                            children: <TextSpan>[
                              TextSpan(
                                text: copy.pinDoesNotMatch,
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
                onNumberSelected:
                    signUpControllerNotifier.addNumberToPinConfirmation,
                onBackspace:
                    signUpControllerNotifier.removeNumberFromPinConfirmation,
              ),
            ),
          ),
          const SizedBox(height: kSmallSpacing),
          PrimaryFilledButton(
            text: copy.confirmPIN,
            onPressed: pin != pinConfirmation
                ? null
                : () async {
                    showTransitionDialog(context, copy.oneMomentPlease);
                    try {
                      if (mnemonicWords.isEmpty) {
                        // Only generate a mnemonic if it hasn't been generated yet.
                        signUpControllerNotifier.generateMnemonic();
                      }
                      await signUpControllerNotifier.setupLightningNode();
                      await signUpControllerNotifier.saveNewAccount();
                      await signUpControllerNotifier.logIn();
                      router.goNamed('pocket');
                    } catch (e) {
                      print(e);
                      try {
                        // Disconnect node here
                        await signUpControllerNotifier.disconnectNode();
                      } catch (e) {
                        print(e);
                      }
                      router.pop();
                    }
                  },
          ),
          const SizedBox(height: kSmallSpacing),
        ],
      ),
    );
  }
}
