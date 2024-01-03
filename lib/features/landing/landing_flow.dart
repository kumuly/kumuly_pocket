import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/landing/pages/landing_screen.dart';
import 'package:kumuly_pocket/features/landing/pages/landing_story_screen.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class LandingFlow extends ConsumerWidget {
  const LandingFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          headline: 'Take full control and become unstoppable',
          description:
              'In Kumuly Pocket your money is really yours. Nobody can stop you from using it as you wish. Only you can access it through your 12 secret words.',
        ),
        const LandingStoryScreen(
            coverImageAssetPath: 'assets/images/mock_up_contact_list.png',
            icon: Text(
              '💕',
              style: TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            headline: 'Get your family and friends on board',
            description:
                'Add contacts and spontaneously send, receive and request money without having to request or generate invoices. So simple, everyone can do it.'),
        const LandingStoryScreen(
          coverImageAssetPath: 'assets/images/mock_up_promo_redeem.png',
          icon: Text(
            '🛍️',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          headline: 'Directly spend sats on products and services',
          description:
              'You can find a constantly growing offering of merchants, products and services accepting bitcoin. No hassle, no selling. Just spend your sats directly and support the circular economy.',
        ),
        const LandingStoryScreen(
          coverImageAssetPath: 'assets/images/mock_up_promo.png',
          icon: Text(
            '🏪',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          headline: 'Let your business be discovered',
          description:
              'Swiftly access merchant features to grow your business on bitcoin. Make your products stand out with exclusive promotions and be embraced by the Bitcoin community.',
        ),
        const LandingScreen(),
      ],
    );
  }
}
