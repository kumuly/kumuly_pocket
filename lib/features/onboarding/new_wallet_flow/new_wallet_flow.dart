import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/onboarding/new_wallet_flow/new_wallet_controller.dart';
import 'package:kumuly_pocket/features/onboarding/new_wallet_flow/pages/new_wallet_created_screen.dart';
import 'package:kumuly_pocket/features/onboarding/new_wallet_flow/pages/new_wallet_invite_code_screen.dart';
import 'package:kumuly_pocket/features/onboarding/pin_setup_flow/pin_setup_flow.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class NewWalletFlow extends ConsumerWidget {
  const NewWalletFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(
      pageViewControllerProvider(
        kNewWalletFlowPageViewId,
      ),
    );
    ref.watch(newWalletControllerProvider(kInviteCodeLength));

    return PageView(
      controller: pageController.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        NewWalletInviteCodeScreen(),
        NewWalletCreatedScreen(),
      ],
    );
  }
}
