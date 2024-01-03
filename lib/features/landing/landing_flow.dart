import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/landing/pages/landing_screen.dart';
import 'package:kumuly_pocket/features/landing/pages/landing_story_screen.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LandingFlow extends ConsumerWidget {
  const LandingFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final pageController = ref.watch(
      pageViewControllerProvider(
        kLandingFlowPageViewId,
      ),
    );

    return PageView(
      controller: pageController.pageController,
      children: [
        LandingStoryScreen(
          coverImageAssetPath: 'assets/images/mock_up_home.png',
          icon: DynamicIcon(
            icon: Image.asset('assets/illustrations/bitcoin_coin.png'),
          ),
          headline: copy.takeFullControlHeadline,
          description: copy.takeFullControlDescription,
        ),
        LandingStoryScreen(
          coverImageAssetPath: 'assets/images/mock_up_contact_list.png',
          icon: const Text(
            '💕',
            style: TextStyle(
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          headline: copy.getYourFamilyAndFriendsOnboardHeadline,
          description: copy.getYourFamilyAndFriendsOnboardDescription,
        ),
        LandingStoryScreen(
          coverImageAssetPath: 'assets/images/mock_up_promo_redeem.png',
          icon: const Text(
            '🛍️',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          headline: copy.directlySpendOnProductsAndServicesHeadline,
          description: copy.directlySpendOnProductsAndServicesDescription,
        ),
        LandingStoryScreen(
          coverImageAssetPath: 'assets/images/mock_up_promo.png',
          icon: const Text(
            '🏪',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          headline: copy.letYourBusinessBeDiscoveredHeadline,
          description: copy.letYourBusinessBeDiscoveredDescription,
        ),
        const LandingScreen(),
      ],
    );
  }
}
