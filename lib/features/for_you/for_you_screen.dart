import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/promo_type.dart';
import 'package:kumuly_pocket/features/for_you/for_you_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';
import 'package:kumuly_pocket/widgets/tabs/chip_tab.dart';

class ForYouScreen extends ConsumerWidget {
  const ForYouScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);

    final state = ref.watch(forYouControllerProvider);
    final notifier = ref.read(forYouControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Palette.neutral[20],
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: kSpacing8,
                ),
                ForYouTabs(
                  tabs: state.tabs,
                  selectedTab: state.selectedTab,
                  onTabSelectHandler: (int index) {
                    notifier.onTabSelectHandler(index);
                  },
                ),
                //PromosRow(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0, -10),
                    spreadRadius: 30,
                    blurRadius: 40,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ForYouTabs extends StatelessWidget {
  const ForYouTabs({
    required this.tabs,
    required this.selectedTab,
    required this.onTabSelectHandler,
    Key? key,
  }) : super(key: key);

  final List<String> tabs;
  final int selectedTab;
  final Function(int) onTabSelectHandler;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: tabs.length, // + 1 for the add button
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? kSpacing2 : 0,
              right: kSpacing2,
            ),
            child: ChipTab(
              label: tabs[index],
              isSelected: selectedTab == index,
              onPressed: index == 0
                  ? () {/*Todo: open tab personalization screen */}
                  : () => onTabSelectHandler(index),
            ),
          );
        },
      ),
    );
  }
}

class PromosRow extends ConsumerWidget {
  PromosRow({
    Key? key,
  }) : super(key: key);

  final List<Promo> promos = [
    Promo(
      id: '1',
      type: PromoType.custom,
      tag: 'Happy Hour',
      headline:
          'Savor limitless servings of Japanese tapas and sake between 5 PM and 7 PM.',
      description:
          'Dive into a tantalizing array of Japanese tapas, expertly crafted by our chefs to tantalize your taste buds. From crispy tempura and savory yakitori to delicate sushi rolls and flavorful gyoza, our menu boasts a variety of traditional and contemporary delights.\n\nComplement your culinary adventure with the smooth and refined taste of premium sake. Served fresh and expertly curated, our sake selection perfectly enhances the flavors of our tapas, providing you with an unforgettable dining experience.',
      images: [
        Image.asset(
          'assets/images/dummy_promo_carousel_1.png',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/dummy_promo_carousel_2.png',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/dummy_promo_carousel_3.png',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/dummy_promo_carousel_4.png',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/dummy_promo_carousel_5.png',
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
      lnurlPayLink:
          'LNURL1DP68GURN8GHJ7WPHXUUKGDRPX3JNSTNY9EMX7MR5V9NK2CTSWQHXJME0D3H82UNVWQH4SDTWW34HW6L9LQU',
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
            height: kSpacing3,
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
                    Palette.neutral[70],
                    FontWeight.w600,
                    wordSpacing: 1,
                  ),
                  color: Palette.neutral[70],
                  trailingIcon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 12,
                    color: Palette.neutral[70],
                  ),
                  onPressed: () {
                    router.pushNamed('promos');
                  },
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
        router.pushNamed(
          'promo-flow',
          pathParameters: {'id': promo.id!},
          extra: promo,
        );
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
                    child: Text(
                      promo.tag, // Your promotion text here
                      style: textTheme.caption1(
                        Colors.white,
                        FontWeight.w500,
                        wordSpacing: 0,
                      ),
                    ),
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
              height: kSpacing1,
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
              height: kSpacing1,
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
              height: kSpacing1,
            ),
          ],
        ),
      ),
    );
  }
}
