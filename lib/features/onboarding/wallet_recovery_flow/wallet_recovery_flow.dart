import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/onboarding/wallet_recovery_flow/pages/wallet_recovery_completed_screen.dart';
import 'package:kumuly_pocket/features/onboarding/wallet_recovery_flow/pages/wallet_recovery_input_screen.dart';
import 'package:kumuly_pocket/features/onboarding/wallet_recovery_flow/wallet_recovery_controller.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class WalletRecoveryFlow extends ConsumerWidget {
  const WalletRecoveryFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(pageViewControllerProvider(
      kWalletRecoveryFlowPageViewId,
    ));
    ref.watch(walletRecoveryControllerProvider);

    return PageView(
      controller: pageController.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        WalletRecoveryInputScreen(),
        WalletRecoveryCompletedScreen(),
      ],
    );
  }
}
