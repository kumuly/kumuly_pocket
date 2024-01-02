import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/landing/landing_screen.dart';
import 'package:kumuly_pocket/features/landing/pages/landing_story_screen.dart';
import 'package:kumuly_pocket/features/onboarding/pages/confirm_pin_screen.dart';
import 'package:kumuly_pocket/features/onboarding/pages/create_pin_screen.dart';
import 'package:kumuly_pocket/features/onboarding/pages/invite_code_screen.dart';
import 'package:kumuly_pocket/features/onboarding/onboarding_controller.dart';
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
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        LandingStoryScreen(),
        LandingScreen(),
      ],
    );
  }
}
