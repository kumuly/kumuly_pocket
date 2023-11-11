import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/cashier_flow/generation/cashier_amount_screen.dart';
import 'package:kumuly_pocket/features/cashier_flow/generation/cashier_generation_controller.dart';
import 'package:kumuly_pocket/features/cashier_flow/paid/cashier_paid_screen.dart';
import 'package:kumuly_pocket/features/cashier_flow/reception/cashier_reception_screen.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class CashierFlow extends ConsumerWidget {
  const CashierFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final pageController = ref.watch(pageViewControllerProvider(
      kCashierFlowPageViewId,
    ));

    return WillPopScope(
      onWillPop: () async {
        if (pageController.pageController.page!.toInt() == 0) {
          router.goNamed('sales');
          return false;
        } else {
          // Invalidate the state to start freh
          ref.invalidate(cashierGenerationControllerProvider);
          pageController.pageController.jumpToPage(0);
          return false;
        }
      },
      child: PageView(
        controller: pageController.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          CashierAmountScreen(),
          CashierReceptionScreen(),
          CashierPaidScreen(),
        ],
      ),
    );
  }
}
