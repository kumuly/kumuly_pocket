import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_border_button.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Image.asset(
              'assets/icons/kumuly_pocket_berry.png',
              color: Palette.lilac[100]!,
            ),
          ),
          const SizedBox(height: kSpacing3),
          Text(
            copy.createAccountPrompt,
            style: textTheme.display4(
              Palette.neutral[70],
              FontWeight.w400,
            ),
          ),
          const SizedBox(height: kSpacing3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PrimaryBorderButton(
                text: copy.createAccount,
                onPressed: () {
                  context.pushNamed('onboarding-flow');
                },
              ),
            ],
          ),
          const SizedBox(height: kSpacing12),
          Text(
            copy.alreadyHaveAnAccount,
            style: textTheme.display3(
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
    );
  }
}
