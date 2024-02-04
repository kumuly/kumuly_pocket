import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/carousels/image_carousel.dart';

class OnboardingStartScreen extends ConsumerWidget {
  const OnboardingStartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          ImageCarousel(
            images: [
              Image.asset(
                'assets/images/mock_up_home.png',
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/images/mock_up_contact_list.png',
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/images/mock_up_promos_list.png',
                fit: BoxFit.cover,
              ),
            ],
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: kSpacing6),
                      child: Text(
                        copy.getStartedPrompt,
                        style: textTheme.body4(
                          Palette.neutral[70],
                          FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: kSpacing3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PrimaryFilledButton(
                          text: copy.getStarted,
                          onPressed: () {
                            router.pushNamed('new-user-flow');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      copy.beenHereBefore,
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
                          text: copy.recoverAccess,
                          onPressed: () {
                            router.pushNamed('recovery-flow');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
