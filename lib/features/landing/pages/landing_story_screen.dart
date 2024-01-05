import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_line_indicator.dart';
import 'package:kumuly_pocket/widgets/shadows/bottom_shadow.dart';

class LandingStoryScreen extends ConsumerWidget {
  const LandingStoryScreen({
    super.key,
    required this.coverImageAssetPath,
    required this.icon,
    required this.headline,
    required this.description,
  });

  final String coverImageAssetPath;
  final Widget icon;
  final String headline;
  final String description;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    final pageController = ref.read(
      pageViewControllerProvider(
        kLandingFlowPageViewId,
      ).notifier,
    );

    const totalPages = 4;
    final currentPage = ref
        .watch(pageViewControllerProvider(
          kLandingFlowPageViewId,
        ))
        .currentPage;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  coverImageAssetPath,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.6,
                ),
                Positioned(
                  top: kSpacing6,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kSpacing2),
                    child: Column(children: [
                      const PageViewLineIndicator(
                        pageViewId: kLandingFlowPageViewId,
                        pageCount: totalPages,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.all(0),
                            onPressed: () => router.goNamed('onboarding'),
                            icon: Icon(
                              Icons.close,
                              color: Colors.white.withOpacity(0.3),
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
                BottomShadow(
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                  spreadRadius: kSpacing10,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kSpacing3,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: Center(child: icon),
                      ),
                      const SizedBox(width: kSpacing2),
                      Expanded(
                        child: Text(
                          headline,
                          style: textTheme.display6(
                            Colors.white,
                            FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: kSpacing2),
                  Text(
                    description,
                    style: textTheme.body3(
                      Palette.neutral[60],
                      FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: kSpacing7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                PrimaryTextButton(
                  text: copy.continueLabel,
                  trailingIcon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                  onPressed: currentPage != totalPages - 1
                      ? pageController.nextPage
                      : () => router.goNamed('onboarding'),
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
