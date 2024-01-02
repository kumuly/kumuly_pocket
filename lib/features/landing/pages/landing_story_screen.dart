import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_line_indicator.dart';
import 'package:kumuly_pocket/widgets/shadows/bottom_shadow.dart';

class LandingStoryScreen extends ConsumerWidget {
  const LandingStoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    final pageController = ref.read(
      pageViewControllerProvider(
        kLandingFlowPageViewId,
      ).notifier,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/mock_up_home.jpeg',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.6,
                ),
                const Positioned(
                  top: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: kSpacing2,
                    ),
                    child: PageViewLineIndicator(
                      pageViewId: kLandingFlowPageViewId,
                      pageCount: 1,
                    ),
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
                        padding: const EdgeInsets.all(kSpacing2),
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: Image.asset(
                          'assets/illustrations/bitcoin_coin.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: kSpacing2),
                      Expanded(
                        child: Text(
                          'Take full control and become unstoppable',
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
                    'In Kumuly Pocket your money is really yours. Nobody can stop you from using it as you wish. Only you can access it through your secret 12 words.',
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
                  onPressed: pageController.nextPage,
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
