import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';

class NewWalletCreatedScreen extends ConsumerWidget {
  const NewWalletCreatedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Palette.neutral[30],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 48,
                  child: DynamicIcon(
                    icon: 'assets/icons/check.svg',
                    color: Palette.success[50],
                    size: 48,
                  ),
                ),
                const SizedBox(height: kSpacing2),
                Text(
                  copy.walletCreated,
                  style: textTheme.display4(
                    Palette.success[50],
                    FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                /*const SizedBox(height: kSpacing1 / 2),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kSpacing4,
                  ),
                  child: Text(
                    'You can back up the generated 12 secret words from the menu at any time.',
                    style: textTheme.body3(
                      Palette.neutral[80],
                      FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),*/
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kSpacing4,
                  ),
                  child: Text(
                    copy.pressContinueAfterWalletCreation,
                    style: textTheme.body3(
                      Palette.neutral[60],
                      FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: kSpacing4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    PrimaryTextButton(
                      text: copy.continueLabel,
                      onPressed: () {
                        router.goNamed('pin-setup-flow');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
