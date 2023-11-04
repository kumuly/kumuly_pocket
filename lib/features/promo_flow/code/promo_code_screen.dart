import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/features/promo_flow/details/promo_details_controller.dart';
import 'package:kumuly_pocket/widgets/promos/promo_description_section.dart';
import 'package:kumuly_pocket/widgets/promos/promo_merchant_info_section.dart';
import 'package:kumuly_pocket/widgets/promos/promo_terms_and_conditions_section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
import 'package:kumuly_pocket/widgets/dividers/dashed_divider.dart';

class PromoCodeScreen extends ConsumerWidget {
  const PromoCodeScreen({Key? key, required this.id, this.promo})
      : super(key: key);

  final String id;
  final Promo? promo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final promoDetailsController = ref.watch(
      promoDetailsControllerProvider(
        id,
        promo,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          copy.promoCode,
          style: textTheme.display4(
            Palette.neutral[100],
            FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            PromoMerchantInfoSection(promoDetailsController.promo.merchant),
            DashedDivider(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40.0),
                  PromoDescriptionSection(
                    promoDetailsController.promo.description,
                  ),
                  const SizedBox(height: 40.0),
                  PromoTermsAndConditionsSection(
                    promoDetailsController.promo.termsAndConditions,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
