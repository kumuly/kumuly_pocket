import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/features/promo_flow/details/promo_payment_controller.dart';
import 'package:kumuly_pocket/widgets/promos/promo_description_section.dart';
import 'package:kumuly_pocket/widgets/promos/promo_merchant_info_section.dart';
import 'package:kumuly_pocket/widgets/promos/promo_price_and_headline_section.dart';
import 'package:kumuly_pocket/widgets/promos/promo_terms_and_conditions_section.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_border_button.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/widgets/carousels/image_carousel.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:kumuly_pocket/widgets/dividers/dashed_divider.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';

class PromoDetailsScreen extends ConsumerWidget {
  const PromoDetailsScreen({Key? key, required this.promo}) : super(key: key);

  final Promo promo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        /*leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Todo: check rout and send to promos or for-you
            router.goNamed('for-you');
          },
        ),*/
        title: Text(
          promo.tag,
          style: textTheme.display4(
            Palette.neutral[100],
            FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border_outlined),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageCarousel(
              width: MediaQuery.of(context).size.width,
              images: promo.images,
            ),
            PromoMerchantInfoSection(promo.merchant),
            DashedDivider(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PromoPriceAndHeadlineSection(
                    promo.originalPrice,
                    promo.discountedPrice,
                    promo.headline,
                  ),
                  const SizedBox(height: 40.0),
                  PromoDescriptionSection(promo.description),
                  const SizedBox(height: 40.0),
                  PromoTermsAndConditionsSection(promo.termsAndConditions),
                  const SizedBox(height: 40.0),
                  PromoPriceAndHeadlineSection(
                    promo.originalPrice,
                    promo.discountedPrice,
                    promo.headline,
                  ),
                  const SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PrimaryBorderButton(
                        text: copy.enjoyPromo,
                        color: Palette.russianViolet[100],
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (context) =>
                                ConfirmPaymentBottomSheetModal(
                              paymentLink: promo.lnurlPayLink,
                              isVerifiedMerchant: promo.merchant.verified,
                              merchantName: promo.merchant.name,
                            ),
                          );
                        },
                      ),
                    ],
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

class ConfirmPaymentBottomSheetModal extends ConsumerWidget {
  const ConfirmPaymentBottomSheetModal({
    required this.paymentLink,
    required this.isVerifiedMerchant,
    required this.merchantName,
    super.key,
  });

  final String paymentLink;
  final bool isVerifiedMerchant;
  final String merchantName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);
    final promoPaymentController = promoPaymentControllerProvider(
      ref.watch(breezeSdkLightningNodeServiceProvider),
    );
    final promoPaymentControllerNotifier = ref.read(
      promoPaymentController.notifier,
    );
    const unit = BitcoinUnit.sat;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: kMediumSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: router.pop,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          isVerifiedMerchant
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      copy.verifiedMerchant.toUpperCase(),
                      style: textTheme.caption1(
                        Palette.neutral[60],
                        FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    DynamicIcon(
                      icon: 'assets/icons/verified.svg',
                      size: 16.0,
                      color: Palette.success[40],
                    ),
                  ],
                )
              : Container(),
          const SizedBox(height: kExtraSmallSpacing),
          Text(
            merchantName,
            style: textTheme.display2(
              Palette.neutral[100],
              FontWeight.w400,
            ),
          ),
          const SizedBox(height: kLargeSpacing),
          Text(
            '99.946 ${unit.name.toUpperCase()}',
            style: textTheme.display6(
              Palette.russianViolet[100],
              FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '= 32 EUR',
            style: textTheme.display2(
              Palette.neutral[60],
              FontWeight.w500,
            ),
          ),
          const SizedBox(height: kSmallSpacing),
          Text(
            '+ Network fee',
            style: textTheme.caption1(
              Palette.blueViolet[100],
              FontWeight.w400,
            ),
          ),
          const SizedBox(height: kLargeSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              PrimaryFilledButton(
                text: copy.confirmPayment,
                fillColor: Palette.neutral[120],
                textColor: Colors.white,
                onPressed: () async {
                  showTransitionDialog(context, copy.oneMomentPlease);
                  //await promoPaymentControllerNotifier.pay(paymentLink);
                  router.pop();
                  // Todo: check rout and send to promos-paid or promo-paid
                  router.goNamed('promo-paid');
                },
              ),
            ],
          ),
          const SizedBox(height: kMediumSpacing),
        ],
      ),
    );
  }
}
