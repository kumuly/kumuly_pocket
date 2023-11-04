// All pages of the promo are shown here
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/amount/receive_sats_amount_screen.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/codes/receive_sats_codes_screen.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/completed/receive_sats_completed_screen.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/receive_sats_controller.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class ReceiveSatsFlow extends ConsumerWidget {
  const ReceiveSatsFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(pageViewControllerProvider);
    final receiveSatsController = receiveSatsControllerProvider(
      ref.watch(breezeSdkLightningNodeServiceProvider),
    );
    final receiveSatsControllerNotifier = ref.read(
      receiveSatsController.notifier,
    );

    final nextHandler = ref.read(pageViewControllerProvider.notifier).nextPage;

    final amount = ref.watch(receiveSatsController).amountSat;
    const unit = BitcoinUnit.sat;

    return PageView(
      controller: pageController.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ReceiveSatsAmountScreen(
          amount: amount,
          unit: unit,
          onAmountChanged: receiveSatsControllerNotifier.amountChangeHandler,
          fetchSwapInfo: receiveSatsControllerNotifier.fetchSwapInfo,
          onNext: nextHandler,
        ),
        ReceiveSatsCodesScreen(onNext: nextHandler),
        const ReceiveSatsCompletedScreen(),
      ],
    );
  }
}
