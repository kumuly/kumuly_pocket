import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/widgets/promos/promo_description_section.dart';
import 'package:kumuly_pocket/widgets/promos/promo_merchant_info_section.dart';
import 'package:kumuly_pocket/widgets/promos/promo_terms_and_conditions_section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
import 'package:kumuly_pocket/widgets/dividers/dashed_divider.dart';

class PromoCodeScreen extends ConsumerWidget {
  const PromoCodeScreen({Key? key, required this.promo}) : super(key: key);

  final Promo promo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Todo: check rout and send to pocket or for you (or just send to pocket always?)
            router.goNamed('pocket');
          },
        ),
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
            PromoMerchantInfoSection(promo.merchant),
            DashedDivider(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40.0),
                  PromoDescriptionSection(promo.description),
                  const SizedBox(height: 40.0),
                  PromoTermsAndConditionsSection(promo.termsAndConditions),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
