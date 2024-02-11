import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/local_currency.dart';
import 'package:kumuly_pocket/features/promo_flow/details/promo_details_controller.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/widgets/amounts/bitcoin_amount_display.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:kumuly_pocket/widgets/promos/promo_description_section.dart';
import 'package:kumuly_pocket/widgets/promos/promo_merchant_info_section.dart';
import 'package:kumuly_pocket/widgets/promos/promo_price_and_headline_section.dart';
import 'package:kumuly_pocket/widgets/promos/promo_terms_and_conditions_section.dart';
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
  const PromoDetailsScreen({
    super.key,
    required this.id,
    this.promo,
  });

  final String id;
  final Promo? promo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final promoDetailsController = ref.watch(promoDetailsControllerProvider(
      id,
      promo,
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          promoDetailsController.promo.tag,
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
              images: promoDetailsController.promo.images,
            ),
            PromoMerchantInfoSection(promoDetailsController.promo.merchant),
            const DashedDivider(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PromoPriceAndHeadlineSection(
                    promoDetailsController.promo.originalPrice,
                    promoDetailsController.promo.discountedPrice,
                    promoDetailsController.promo.headline,
                  ),
                  const SizedBox(height: 40.0),
                  PromoDescriptionSection(
                      promoDetailsController.promo.description),
                  const SizedBox(height: 40.0),
                  PromoTermsAndConditionsSection(
                    promoDetailsController.promo.termsAndConditions,
                  ),
                  const SizedBox(height: 40.0),
                  PromoPriceAndHeadlineSection(
                    promoDetailsController.promo.originalPrice,
                    promoDetailsController.promo.discountedPrice,
                    promoDetailsController.promo.headline,
                  ),
                  const SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PrimaryBorderButton(
                        text: copy.enjoyPromo,
                        color: Palette.russianViolet[100],
                        onPressed: () {
                          // Fetch amount to pay in satoshis
                          ref
                              .read(promoDetailsControllerProvider(id, promo)
                                  .notifier)
                              .fetchAmountToPayInSat();

                          showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (context) =>
                                ConfirmPaymentBottomSheetModal(
                              id: id,
                              promo: promo,
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
    required this.id,
    this.promo,
    super.key,
  });

  final String id;
  final Promo? promo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);

    final state = ref.watch(promoDetailsControllerProvider(id, promo));

    final localCurrency = ref.watch(localCurrencyProvider);
    final sufficientBalance =
        ref.watch(spendableBalanceSatProvider).asData?.value != null &&
                state.amountSat != null
            ? ref.watch(spendableBalanceSatProvider).asData!.value >=
                state.amountSat!
            : false;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: kSpacing3),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: router.pop,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          state.promo.merchant.verified
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
          const SizedBox(height: kSpacing1),
          Text(
            state.promo.merchant.name,
            style: textTheme.display2(
              Palette.neutral[100],
              FontWeight.w400,
            ),
          ),
          const SizedBox(height: kSpacing8),
          state.amountSat == null
              ? const CircularProgressIndicator()
              : BitcoinAmountDisplay(
                  amountSat: state.amountSat,
                  amountStyle: textTheme.display6(
                    Palette.russianViolet[100],
                    FontWeight.w500,
                  ),
                ),
          const SizedBox(height: 2),
          Text(
            '= ${state.promo.discountedPrice} ${localCurrency.code.toUpperCase()}',
            style: textTheme.display2(
              Palette.neutral[60],
              FontWeight.w500,
            ),
          ),
          const SizedBox(height: kSpacing2),
          Text(
            copy.plusNetworkFee,
            style: textTheme.caption1(
              Palette.blueViolet[100],
              FontWeight.w400,
            ),
          ),
          SizedBox(
            height: kSpacing8,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  state.priceUpdatedError
                      ? Text(
                          copy.priceUpdatedError,
                          style: textTheme.caption1(
                            Palette.error[100],
                            FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : state.paymentErrorMessage != null &&
                              state.paymentErrorMessage!.isNotEmpty
                          ? Text(
                              state.paymentErrorMessage!,
                              style: textTheme.caption1(
                                Palette.error[100],
                                FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : Container(),
                  const SizedBox(height: kSpacing1),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              PrimaryFilledButton(
                text: copy.confirmPayment,
                fillColor: Palette.neutral[120],
                textColor: Colors.white,
                onPressed: !sufficientBalance
                    ? null
                    : () async {
                        try {
                          showTransitionDialog(context, copy.oneMomentPlease);
                          await ref
                              .read(promoDetailsControllerProvider(id, promo)
                                  .notifier)
                              .payForPromo();
                          router.pop();
                          router.pop();
                          ref
                              .read(pageViewControllerProvider(
                                kPromoFlowPageViewId,
                              ).notifier)
                              .nextPage();
                        } catch (e) {
                          router.pop();
                          print(e);
                        }
                      },
              ),
            ],
          ),
          const SizedBox(height: kSpacing3),
        ],
      ),
    );
  }
}
