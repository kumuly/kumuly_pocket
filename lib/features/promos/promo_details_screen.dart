import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/features/promos/promo_payment_controller.dart';
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
    final router = GoRouter.of(context);

    // Todo: catch back button press and send to promos-paid or promo-paid
    return WillPopScope(
      onWillPop: () async {
        router.goNamed('for-you');
        return false; // Prevent the default behavior (closing the app or popping the route)
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Todo: check rout and send to promos-paid or promo-paid
              router.goNamed('for-you');
            },
          ),
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
              MerchantInfoSection(promo.merchant),
              DashedDivider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PriceAndHeadlineSection(
                      promo.originalPrice,
                      promo.discountedPrice,
                      promo.headline,
                    ),
                    const SizedBox(height: 40.0),
                    DescriptionSection(promo.description),
                    const SizedBox(height: 40.0),
                    TermsAndConditionsSection(promo.termsAndConditions),
                    const SizedBox(height: 40.0),
                    PriceAndHeadlineSection(
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
      ),
    );
  }
}

class MerchantInfoSection extends StatelessWidget {
  const MerchantInfoSection(this.merchant, {super.key});

  final PromoMerchant merchant;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                height: 40,
                width: 40,
                child: merchant.logo,
              ),
              const SizedBox(width: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        merchant.name,
                        style: textTheme.display3(
                          Palette.neutral[80],
                          FontWeight.w400,
                          wordSpacing: 0,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      merchant.verified
                          ? DynamicIcon(
                              icon: 'assets/icons/verified.svg',
                              size: 16.0,
                              color: Palette.success[40],
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            color: index + 1 > merchant.rating
                                ? Palette.neutral[40]
                                : Palette.warning[40],
                            size: 16.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '${merchant.rating}',
                        style: textTheme.caption1(
                          Palette.neutral[40],
                          FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          // Address Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                merchant.address,
                style: textTheme.display1(
                  Palette.neutral[70],
                  FontWeight.w400,
                  wordSpacing: 0,
                ),
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  DynamicIcon(
                    icon: 'assets/icons/direction.svg',
                    color: Palette.russianViolet[100],
                    size: 16.0,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    merchant.distance.toUpperCase(),
                    style: textTheme.caption1(
                      Palette.russianViolet[100],
                      FontWeight.w600,
                      wordSpacing: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PriceAndHeadlineSection extends StatelessWidget {
  const PriceAndHeadlineSection(
    this.originalPrice,
    this.discountedPrice,
    this.headline, {
    Key? key,
  }) : super(key: key);

  final double originalPrice;
  final double discountedPrice;
  final String headline;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              discountedPrice.floor() == discountedPrice
                  ? discountedPrice.toStringAsFixed(0)
                  : discountedPrice.toStringAsFixed(2),
              style: textTheme.display6(
                Palette.neutral[120],
                FontWeight.w400,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              heightFactor: 1.5,
              child: Text(
                '€',
                style: textTheme.caption1(
                  Palette.neutral[120],
                  FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 4.0),
            discountedPrice == originalPrice
                ? Container()
                : Text(
                    originalPrice.floor() == originalPrice
                        ? originalPrice.toStringAsFixed(0)
                        : originalPrice.toStringAsFixed(2),
                    style: textTheme
                        .caption1(
                          Palette.neutral[40],
                          FontWeight.w400,
                        )
                        .copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
          ],
        ),
        const SizedBox(height: 4.0),
        Text(
          headline,
          style: textTheme.body4(
            Palette.neutral[80],
            FontWeight.w400,
            wordSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class DescriptionSection extends StatelessWidget {
  const DescriptionSection(
    this.description, {
    Key? key,
  }) : super(key: key);

  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          copy.promoDescriptionTitle,
          style: textTheme.display2(
            Palette.neutral[120],
            FontWeight.w500,
            wordSpacing: 0,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          description,
          style: textTheme.body3(
            Palette.neutral[70],
            FontWeight.w400,
            wordSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class TermsAndConditionsSection extends StatelessWidget {
  const TermsAndConditionsSection(
    this.termsAndConditions, {
    Key? key,
  }) : super(key: key);

  final List<String> termsAndConditions;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          copy.promoTermsAndConditionsTitle,
          style: textTheme.display2(
            Palette.neutral[120],
            FontWeight.w500,
            wordSpacing: 0,
          ),
        ),
        const SizedBox(height: 12.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            termsAndConditions.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${index + 1}.'),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: Text(
                      termsAndConditions[index],
                      style: Theme.of(context).textTheme.body3(
                            Palette.neutral[70],
                            FontWeight.w400,
                            wordSpacing: 0,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
            mainAxisSize: MainAxisSize.min,
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
