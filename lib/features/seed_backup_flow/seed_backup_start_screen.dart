import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class SeedBackupStartScreen extends ConsumerWidget {
  const SeedBackupStartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);
    final width = MediaQuery.of(context).size.width;

    final pageController = ref
        .read(pageViewControllerProvider(kSeedBackupFlowPageViewId).notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: kSpacing10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kSpacing4,
                ),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: kSpacing3,
                    mainAxisSpacing: kSpacing4,
                    childAspectRatio: 4,
                  ),
                  itemBuilder: (context, index) => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${index + 1}.',
                            style: textTheme.display4(
                              Palette.neutral[60],
                              FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: kSpacing3),
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Text(
                              'test',
                              style: textTheme.display4(
                                Palette.neutral[100],
                                FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider(color: Palette.neutral[20]),
                    ],
                  ),
                ),
              ),
            ],
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Palette.neutral[40]!.withOpacity(0.2),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: width,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 24),
                    spreadRadius: 12,
                    blurRadius: 48,
                    color: Color.fromRGBO(154, 170, 207, 0.55),
                  ),
                ],
              ),
              child: Card(
                color: Colors.white,
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(kSpacing3),
                    topRight: Radius.circular(kSpacing3),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    kSpacing3,
                    kSpacing8,
                    kSpacing3,
                    kSpacing3,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        copy.recoveryOrSeedPhrase,
                        style: textTheme.display5(
                          Palette.blueViolet[100],
                          FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: kSpacing1),
                      Text(
                        copy.recoveryOrSeedPhraseDescription,
                        style: textTheme.body4(
                          Palette.neutral[80],
                          FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: kSpacing3),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Palette.neutral[20],
                        ),
                        child: Icon(
                          Icons.timer_outlined,
                          color: Palette.blueViolet[100],
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: kSpacing1),
                      Text(
                        copy.take5MinutesToBackupYourSeedPhrase,
                        style: textTheme.body3(
                          Palette.blueViolet[100],
                          FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: kSpacing8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PrimaryFilledButton(
                            text: copy.obtainSeed,
                            fillColor: Palette.russianViolet[100],
                            onPressed: () => {
                              pageController.nextPage(),
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: kSpacing2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          PrimaryTextButton(
                            text: copy.betterAtAnotherTime,
                            onPressed: router.pop,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
