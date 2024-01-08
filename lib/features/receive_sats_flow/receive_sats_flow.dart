// All pages of the promo are shown here
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/pages/receive_sats_amount_screen.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/pages/receive_sats_invoices_screen.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/receive_sats_controller.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/pages/receive_sats_completed_screen.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class ReceiveSatsFlow extends ConsumerWidget {
  const ReceiveSatsFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(pageViewControllerProvider(
      kReceiveSatsFlowPageViewId,
    ));

    ref.watch(receiveSatsControllerProvider);

    return PageView(
      controller: pageController.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        ReceiveSatsAmountScreen(),
        ReceiveSatsInvoicesScreen(),
        ReceiveSatsCompletedScreen(),
      ],
    );
  }
}
