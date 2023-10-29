import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/promo_type.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';
import 'package:kumuly_pocket/widgets/shadows/bottom_shadow.dart';

class ForYouScreen extends ConsumerWidget {
  const ForYouScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: kMediumSpacing,
                  ),
                  PromosRow(),
                ],
              ),
            ),
            BottomShadow(
              width: screenWidth,
            ),
          ],
        ));
  }
}

class PromosRow extends ConsumerWidget {
  PromosRow({
    Key? key,
  }) : super(key: key);

  final List<Promo> promos = [
    Promo(
      type: PromoType.custom,
      tag: 'Happy Hour',
      headline:
          'Savor limitless servings of Japanese tapas and sake between 5 PM and 7 PM.',
      description:
          'Dive into a tantalizing array of Japanese tapas, expertly crafted by our chefs to tantalize your taste buds. From crispy tempura and savory yakitori to delicate sushi rolls and flavorful gyoza, our menu boasts a variety of traditional and contemporary delights. Complement your culinary adventure with the smooth and refined taste of premium sake. Served fresh and expertly curated, our sake selection perfectly enhances the flavors of our tapas, providing you with an unforgettable dining experience.',
      images: [
        Image.asset(
          'assets/images/dummy_promo.png',
          fit: BoxFit.cover,
        ),
      ],
      originalPrice: 32,
      discountValue: 0,
      termsAndConditions: const [
        'This promotion is only valid for payments made with Bitcoin.',
        'Is exclusively available at Oishiki restaurant on Tuesdays, Wednesdays, and Thursdays from 5:00 PM to 7:00 PM.',
        'This promotion is for sake only; other drinks are not included.',
        'Takeout and delivery orders are not eligible for this promotion.',
        'Cannot be shared with other guests or taken away for later consumption.',
        'Guests must be of legal drinking age to consume sake.',
      ],
      merchant: PromoMerchant(
        id: "1",
        logo: Image.asset(
          'assets/images/dummy_logo.png',
          fit: BoxFit.cover,
        ),
        name: 'Oishiki Japanese Food',
        verified: true,
        rating: 4.5,
        address: '1234 Main Street, New York, NY 10001',
        distance: 'Nearby - 2km',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: kMediumSpacing,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Text(
              copy.promos.toUpperCase(),
              style: textTheme.display3(
                Palette.neutral[60],
                FontWeight.w500,
                letterSpacing: 3,
              ),
            ),
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: promos.length, // Todo: change this to items.length
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 16 : 8,
                    right: index == 5 - 1
                        ? 16
                        : 8, // Todo: change 5 to items.length
                  ),
                  child: PromoCard(promos[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PrimaryTextButton(
                  text: copy.moreDeals,
                  textStyle: textTheme.body3(
                      Palette.neutral[70], FontWeight.w600,
                      wordSpacing: 1),
                  color: Palette.neutral[70],
                  trailingIcon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 12,
                    color: Palette.neutral[70],
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Divider(
            color: Palette.neutral[30],
            thickness: 1,
          )
        ],
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  const PromoCard(this.promo, {super.key});

  final Promo promo;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);

    return InkWell(
      onTap: () {
        router.pushNamed('promo', extra: promo);
      },
      borderRadius: const BorderRadius.all(
          Radius.circular(14)), // This matches the Container's border radius
      child: Container(
        width: 184,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: Palette.neutral[30]!,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(14),
          ),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                // Main image container
                Container(
                  height: 136,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: promo.images[0],
                ),
                // Promotion tag at the top left
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ), // Adjust padding as necessary
                    decoration: BoxDecoration(
                      color: Palette
                          .neutral[100], // Color for your promotion background
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                      ),
                    ),
                    child: Text(promo.tag, // Your promotion text here
                        style: textTheme.caption1(
                          Colors.white,
                          FontWeight.w500,
                        )),
                  ),
                ),
                // Merchant logo at the top right
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      shape:
                          BoxShape.circle, // this makes the container circular
                      border: Border.all(
                        color:
                            Colors.white, // choose the border color you desire
                        width: 1, // adjust the border width as you like
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor:
                          Palette.neutral[100], // Placeholder for the logo
                      radius: 8,
                      foregroundImage: promo.merchant.logo.image,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: kExtraSmallSpacing,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    promo.discountedPrice == promo.originalPrice
                        ? Container()
                        : Text(promo.originalPrice.toString(),
                            style: textTheme
                                .display1(
                                  Palette.neutral[70],
                                  FontWeight.w400,
                                )
                                .copyWith(
                                  decoration: TextDecoration.lineThrough,
                                )),
                    Text(
                      promo.discountedPrice.floor() == promo.discountedPrice
                          ? promo.discountedPrice.toStringAsFixed(0)
                          : promo.discountedPrice.toStringAsFixed(2),
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
                  ],
                ),
                Text('1km',
                    style: textTheme.caption1(
                      Palette.neutral[60],
                      FontWeight.w500,
                    )),
              ],
            ),
            const SizedBox(
              height: kExtraSmallSpacing,
            ),
            Expanded(
              child: Text(
                promo.headline,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.justify,
                style: textTheme.body1(
                  Palette.neutral[80],
                  FontWeight.w400,
                  wordSpacing: 0,
                  letterSpacing: 0,
                ),
              ),
            ),
            const SizedBox(
              height: kExtraSmallSpacing,
            ),
          ],
        ),
      ),
    );
  }
}
