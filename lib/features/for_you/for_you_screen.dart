import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
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
                  PromosRow(),
                  PromosRow(),
                  PromosRow(),
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

  final List<Promo> promos = [Promo(), Promo(), Promo(), Promo(), Promo()];

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
              itemCount: 5, // Todo: change this to items.length
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 16 : 8,
                    right: index == 5 - 1
                        ? 16
                        : 8, // Todo: change 5 to items.length
                  ),
                  child: const PromoCard(),
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
                  text: 'More deals',
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
  const PromoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
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
                decoration: BoxDecoration(
                  color: Palette.neutral[70],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
              ),
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
                  child: Text('-50%', // Your promotion text here
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
                child: CircleAvatar(
                  backgroundColor:
                      Palette.neutral[100], // Placeholder for the logo
                  radius: 8,
                ),
              ),
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
                  Text('€32',
                      style: textTheme
                          .display1(
                            Palette.neutral[70],
                            FontWeight.w400,
                          )
                          .copyWith(
                            decoration: TextDecoration.lineThrough,
                          )),
                  Text(
                    '16',
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
              'Ut enim ad minim veniam, nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo con ion ul...',
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
    );
  }
}
