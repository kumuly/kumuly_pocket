import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/shadows/bottom_shadow.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/mock_up_promos_list.jpeg',
                  height: MediaQuery.of(context).size.height * 0.6,
                  fit: BoxFit.cover,
                ),
                BottomShadow(
                  width: MediaQuery.of(context).size.width,
                  spreadRadius: kSpacing10,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing8),
              child: RichText(
                text: TextSpan(
                  text: copy.createAccountPrompt1,
                  style: textTheme.body4(
                    Palette.neutral[70],
                    FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: copy.createAccountPrompt2,
                      style: textTheme.body4(
                        Palette.neutral[70],
                        FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: copy.createAccountPrompt3,
                      style: textTheme.body4(
                        Palette.neutral[70],
                        FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: kSpacing3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryFilledButton(
                  text: copy.createAccount,
                  onPressed: () {
                    context.pushNamed('onboarding-flow');
                  },
                ),
              ],
            ),
            const SizedBox(height: kSpacing9),
            Text(
              copy.alreadyHaveAnAccount,
              style: textTheme.body3(
                Palette.neutral[60],
                FontWeight.w500,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                PrimaryTextButton(
                  text: copy.importAccount,
                  onPressed: () {
                    context.pushNamed('seed-recovery-flow');
                  },
                ),
              ],
            ),
            const SizedBox(height: kSpacing3),
          ],
        ),
      ),
    );
  }
}
