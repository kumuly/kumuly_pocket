import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/services/account_service.dart';
import 'package:kumuly_pocket/services/authentication_service.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/features/sign_up/sign_up_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssignAliasScreen extends ConsumerWidget {
  const AssignAliasScreen({Key? key}) : super(key: key);

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
    final alias = ref.watch(signUpController).alias;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          copy.assignAlias,
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
                const SizedBox(height: kMediumSpacing),
                Text(
                  copy.assignAliasDescriptionPart1,
                  textAlign: TextAlign.center,
                  style: textTheme.body2(
                    Palette.neutral[100]!.withOpacity(0.3),
                    FontWeight.w400,
                  ),
                ),
                const SizedBox(height: kSmallSpacing),
                Text(
                  copy.assignAliasDescriptionPart2,
                  textAlign: TextAlign.center,
                  style: textTheme.body2(
                    Palette.neutral[100]!.withOpacity(0.3),
                    FontWeight.w400,
                  ),
                ),
                const SizedBox(height: kExtraLargeSpacing),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  style: textTheme.display6(
                      Palette.neutral[100], FontWeight.normal),
                  decoration: InputDecoration(
                    hintText: copy.insertNameOrAliasHere,
                    hintStyle: textTheme.display6(
                      Palette.neutral[50],
                      FontWeight.normal,
                    ),
                    // Set the line color when the TextField is enabled but not focused
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Palette.neutral[50]!,
                      ), // Change this to your desired color
                    ),
                    // Set the line color when the TextField is focused
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Palette.neutral[100]!,
                      ), // Change this to your desired color
                    ),
                    // Set the line color when there's an error (optional)
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Palette.error[100]!,
                      ), // Change this to your desired color
                    ),
                    // Set the line color when there's an error and the field is focused (optional)
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Palette.error[50]!,
                      ), // Change this to your desired color
                    ),
                  ),
                  onChanged: signUpControllerNotifier.setAlias,
                ),
              ],
            ),
          ),
          const SizedBox(height: kLargeSpacing),
          PrimaryFilledButton(
            text: copy.confirmAlias,
            onPressed:
                alias.isEmpty ? null : () => context.pushNamed('create-pin'),
            width: 200,
          ),
          const SizedBox(height: kMediumSpacing),
        ],
      ),
    );
  }
}
