// All pages of the promo are shown here
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/promo_flow/details/promo_details_controller.dart';
import 'package:kumuly_pocket/features/promo_flow/details/promo_details_screen.dart';
import 'package:kumuly_pocket/features/promo_flow/paid/promo_paid_screen.dart';
import 'package:kumuly_pocket/features/promo_flow/code/promo_code_screen.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class PromoFlow extends ConsumerWidget {
  const PromoFlow({
    super.key,
    required this.id,
    this.promo,
  });

  final String id;
  final Promo? promo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(pageViewControllerProvider(
      kPromoFlowPageViewId,
    ));
    ref.watch(promoDetailsControllerProvider(id, promo));

    return PageView(
      controller: pageController.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        PromoDetailsScreen(id: id, promo: promo),
        const PromoPaidScreen(),
        PromoCodeScreen(id: id, promo: promo)
      ],
    );
  }
}
