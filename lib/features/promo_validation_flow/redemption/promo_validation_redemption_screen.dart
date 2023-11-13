import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/promo_validation_flow/redemption/promo_validation_redemption_controller.dart';
import 'package:kumuly_pocket/features/promo_validation_flow/scanner/promo_validation_scanner_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:kumuly_pocket/widgets/dividers/dashed_divider.dart';
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
    final router = GoRouter.of(context);
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
              router.pop();
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing2),
        child: Column(
          children: [
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
            Stack(fit: StackFit.loose, children: [
              ClipRect(
                child: NumberedList(
                  listItems: promo.termsAndConditions,
                  maxItems: 4,
                ),
              ),
              BottomShadow(
                  width: MediaQuery.of(context).size.width, spreadRadius: 40),
            ]),
            DashedDivider(),
            const SizedBox(height: kSpacing5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                PrimaryFilledButton(
                  text: copy.validatePromo,
                  onPressed: () async {
                    try {
                      final validatingPromo = ref
                          .read(
                            promoValidationRedemptionControllerProvider
                                .notifier,
                          )
                          .validate();
                      showTransitionDialog(context, copy.oneMomentPlease);
                      await validatingPromo;
                      router.pop();
                      ref
                          .read(pageViewControllerProvider(
                            kPromoValidationFlowPageViewId,
                          ).notifier)
                          .nextPage();
                    } catch (e) {
                      print(e);
                      router.pop();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: kSpacing2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                PrimaryTextButton(
                  text: copy.cancelPromo,
                  onPressed: () async {
                    try {
                      final cancellingPromo = ref
                          .read(
                            promoValidationRedemptionControllerProvider
                                .notifier,
                          )
                          .cancel();
                      showTransitionDialog(context, copy.oneMomentPlease);
                      await cancellingPromo;
                      router.pop();
                      ref
                          .read(pageViewControllerProvider(
                            kPromoValidationFlowPageViewId,
                          ).notifier)
                          .nextPage();
                    } catch (e) {
                      print(e);
                      router.pop();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: kSpacing3),
            Text(
              copy.validateIfProductOrServiceIsStillAvailable,
              style: textTheme.display1(Palette.neutral[60], FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kSpacing8),
          ],
        ),
      ),
    );
  }
}
