import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/promos/rating_stars.dart';

class PromoMerchantInfoSection extends StatelessWidget {
  const PromoMerchantInfoSection(this.merchant, {super.key});

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
                      RatingStars(
                        rating: merchant.rating,
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
