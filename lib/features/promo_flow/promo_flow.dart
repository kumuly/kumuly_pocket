// All pages of the promo are shown here
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/features/promo_flow/details/promo_details_screen.dart';
import 'package:kumuly_pocket/features/promo_flow/paid/promo_paid_screen.dart';
import 'package:kumuly_pocket/features/promo_flow/code/promo_code_screen.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class PromoFlow extends ConsumerWidget {
  const PromoFlow({super.key, required this.promo});

  final Promo promo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(pageViewControllerProvider);

    return PageView(
      controller: pageController.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        PromoDetailsScreen(promo: promo),
        const PromoPaidScreen(),
        PromoCodeScreen(promo: promo)
      ],
    );
  }
}
