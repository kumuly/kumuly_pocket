import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/promo_validation_flow/scanner/promo_validation_scanner_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';
import 'package:kumuly_pocket/widgets/lists/numbered_list.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/shadows/bottom_shadow.dart';

class PromoValidationRedemptionScreen extends ConsumerWidget {
  const PromoValidationRedemptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    final promo = ref.watch(promoValidationScannerControllerProvider).promo;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Palette.neutral[100]!,
              size: 24.0,
            ),
            onPressed: () {
              // Reset the state
              ref.invalidate(promoValidationScannerControllerProvider);
              ref
                  .read(pageViewControllerProvider(
                    kPromoValidationFlowPageViewId,
                  ).notifier)
                  .previousPage();
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing2),
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight),
            CircleAvatar(
              backgroundImage: promo?.merchant.logo.image,
              radius: 10,
            ),
            const SizedBox(height: kSpacing1 / 2),
            Text(
              promo!.merchant.name,
              textAlign: TextAlign.center,
              style: textTheme.display1(
                Palette.neutral[60],
                FontWeight.w400,
              ),
            ),
            const SizedBox(height: kSpacing7),
            Text(
              promo.tag,
              style: textTheme.display7(Palette.neutral[120], FontWeight.w500),
            ),
            const SizedBox(height: kSpacing1 * 1.5),
            Text(
              promo.headline,
              style: textTheme.body4(
                Palette.neutral[80],
                FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kSpacing13),
            SizedBox(
              height: 208,
              child: Stack(children: [
                ClipRect(
                  child: NumberedList(
                    listItems: promo.termsAndConditions,
                  ),
                ),
                BottomShadow(width: MediaQuery.of(context).size.width),
              ]),
            ),
            const SizedBox(height: kSpacing5),
            PrimaryFilledButton(
              text: copy.validatePromo,
              onPressed: () {},
            ),
            const SizedBox(height: kSpacing2),
            PrimaryTextButton(text: copy.cancelPromo, onPressed: () {}),
            const SizedBox(height: kSpacing3),
            Text(
              copy.validateIfProductOrServiceIsStillAvailable,
              style: textTheme.display1(Palette.neutral[60], FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
