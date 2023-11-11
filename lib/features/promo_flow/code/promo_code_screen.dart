import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/promo_flow/code/promo_code_controller.dart';
import 'package:kumuly_pocket/widgets/carousels/image_carousel.dart';
import 'package:kumuly_pocket/widgets/clippers/ripped_paper_clipper.dart';
import 'package:kumuly_pocket/widgets/containers/ripped_paper_container.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/promos/promo_description_section.dart';
import 'package:kumuly_pocket/widgets/promos/promo_merchant_info_section.dart';
import 'package:kumuly_pocket/widgets/promos/promo_terms_and_conditions_section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
import 'package:kumuly_pocket/widgets/dividers/dashed_divider.dart';
import 'package:kumuly_pocket/widgets/promos/rating_stars.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PromoCodeScreen extends ConsumerWidget {
  const PromoCodeScreen({Key? key, required this.id, this.promo})
      : super(key: key);

  final String id;
  final Promo? promo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final promoCodeController = ref.watch(
      promoCodeControllerProvider(
        id,
        promo,
      ),
    );
    final isRedeemed = promoCodeController.isRedeemed ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isRedeemed ? 'Promo' : copy.promoCode,
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
            PromoCodeAndInstructionsSection(
              promo: promoCodeController.promo,
              paymentHash: promoCodeController.paymentHash,
              isRedeemed: isRedeemed,
            ),
            isRedeemed
                ? const SizedBox()
                : Column(
                    children: [
                      DashedDivider(),
                      PromoMerchantInfoSection(
                          promoCodeController.promo.merchant),
                      DashedDivider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              promoCodeController.promo.tag,
                              style: textTheme.display6(
                                Palette.neutral[120],
                                FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              promoCodeController.promo.headline,
                              style: textTheme.body4(
                                Palette.neutral[80],
                                FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 40.0),
                            SizedBox(
                              height: 212,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    promoCodeController.promo.images.length,
                                itemBuilder: (context, index) {
                                  final itemCount =
                                      promoCodeController.promo.images.length;
                                  return Padding(
                                    padding: itemCount > 1 && index == 0
                                        ? const EdgeInsets.only(right: 4.0)
                                        : itemCount > 1 &&
                                                index == itemCount - 1
                                            ? const EdgeInsets.only(left: 4.0)
                                            : const EdgeInsets.symmetric(
                                                horizontal: 4.0,
                                              ), // Adjust the spacing between images
                                    child:
                                        promoCodeController.promo.images[index],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 40.0),
                            PromoDescriptionSection(
                              promoCodeController.promo.description,
                            ),
                            const SizedBox(height: 40.0),
                            PromoTermsAndConditionsSection(
                              promoCodeController.promo.termsAndConditions,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class PromoCodeAndInstructionsSection extends StatelessWidget {
  const PromoCodeAndInstructionsSection({
    Key? key,
    required this.promo,
    this.paymentHash,
    required this.isRedeemed,
  }) : super(key: key);

  final Promo promo;
  final String? paymentHash;
  final bool isRedeemed;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 360,
              width: double.infinity,
              child: promo.images[0],
            ),
            const SizedBox(height: 112),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: !isRedeemed
                  ? Column(
                      children: [
                        Text(
                          copy.pointingUpEmoji,
                          style: textTheme.display7(
                              Palette.neutral[100], FontWeight.w700),
                        ),
                        const SizedBox(height: kSpacing3),
                        Text(
                          copy.showThisQrCodeAt,
                          style: textTheme.display5(
                            Palette.neutral[120],
                            FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          promo.merchant.address,
                          style: textTheme.display2(
                            Palette.neutral[70],
                            FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextButton.icon(
                          onPressed: () {/* Todo: show map*/},
                          icon: DynamicIcon(
                            icon: 'assets/icons/direction.svg',
                            color: Palette.blueViolet[100],
                            size: 12.0,
                          ),
                          label: Text(
                            copy.seeOnMap.toUpperCase(),
                            style: textTheme.caption1(
                              Palette.blueViolet[100],
                              FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: kSpacing8),
                        Text(
                          copy.redemptionExplanation,
                          textAlign: TextAlign.center,
                          style: textTheme.body3(
                            Palette.neutral[70],
                            FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          promo.tag,
                          style: textTheme.display6(
                            Palette.neutral[50],
                            FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          promo.headline,
                          style: textTheme.body3(
                            Palette.neutral[50],
                            FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 74),
                        RatingStars(
                          rating: promo.merchant.rating,
                          starSize: 32,
                          starBorder: true,
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        const SizedBox(height: 4),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Rate your experience',
                            style: textTheme.display2(
                              Palette.neutral[120],
                              FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
            ),
            const SizedBox(height: 40),
          ],
        ),
        Positioned(
          top: 144 - kToolbarHeight,
          left: (MediaQuery.of(context).size.width - 264) / 2,
          child: PromoCodeContainer(
            promo: promo,
            paymentHash: paymentHash,
            isRedeemed: isRedeemed,
          ),
        ),
      ],
    );
  }
}

class PromoCodeContainer extends StatelessWidget {
  const PromoCodeContainer({
    super.key,
    required this.promo,
    this.paymentHash,
    required this.isRedeemed,
    this.width = 264.0,
    this.height = 336.0,
  });

  final Promo promo;
  final String? paymentHash;
  final bool isRedeemed;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return RippedPaperContainer(
      height: height,
      width: width,
      child: paymentHash == null
          ? const Text('Something went wrong.')
          : !isRedeemed
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    QrImageView(
                      data: paymentHash!,
                      embeddedImage: promo.merchant.logo.image,
                      embeddedImageStyle: const QrEmbeddedImageStyle(
                        size: Size(32, 32),
                      ),
                      padding: const EdgeInsets.all(32.0),
                    ),
                    const SizedBox(height: kSpacing2),
                    Text(
                      '${copy.validUntil} 17/12/2023',
                      style: textTheme.display2(
                        Palette.neutral[70],
                        FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Spacer(),
                          Image(
                            image: promo.merchant.logo.image,
                            height: 32,
                            width: 32,
                          ),
                          const SizedBox(height: kSpacing2),
                          Text(
                            promo.merchant.name,
                            style: textTheme.display1(
                              Palette.neutral[70],
                              FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    Text(
                      'Promo redeemed'.toUpperCase(),
                      style: textTheme.caption1(
                        Palette.success[100],
                        FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '17/12/2023',
                      style: textTheme.display2(
                        Palette.neutral[50],
                        FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 38),
                  ],
                ),
    );
  }
}
