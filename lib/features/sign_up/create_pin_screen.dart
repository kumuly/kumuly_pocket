import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/services/account_service.dart';
import 'package:kumuly_pocket/services/authentication_service.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/widgets/pin/numeric_keyboard.dart';
import 'package:kumuly_pocket/widgets/pin/pin_code_display.dart';
import 'package:kumuly_pocket/features/sign_up/sign_up_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreatePinScreen extends ConsumerWidget {
  const CreatePinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final signUpController = signUpControllerProvider(
      ref.watch(firebaseAuthenticationServiceProvider),
      ref.watch(sharedPreferencesAccountServiceProvider),
      ref.watch(breezeSdkLightningNodeServiceProvider),
    );
    final signUpControllerNotifier = ref.read(
      signUpController.notifier,
    );
    final pin = ref.watch(signUpController).pin;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          copy.createPIN,
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
                    copy.createPINDescription,
                    textAlign: TextAlign.center,
                    style: textTheme.body2(
                        Palette.neutral[100]!.withOpacity(0.3),
                        FontWeight.w400),
                  ),
                ),
                const SizedBox(height: kLargeSpacing),
                PinCodeDisplay(pinCode: pin),
                const SizedBox(height: kExtraSmallSpacing),
                const SizedBox(
                  height: 20, // Adjust this to a suitable height
                ),
              ],
            ),
          ),
          const SizedBox(height: kExtraSmallSpacing),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: NumericKeyboard(
                onNumberSelected: signUpControllerNotifier.addNumberToPin,
                onBackspace: signUpControllerNotifier.removeNumberFromPin,
              ),
            ),
          ),
          const SizedBox(height: kSmallSpacing),
          PrimaryFilledButton(
            text: copy.continueLabel,
            onPressed:
                pin.length != 4 ? null : () => context.pushNamed('confirm-pin'),
          ),
          const SizedBox(height: kSmallSpacing),
        ],
      ),
    );
  }
}