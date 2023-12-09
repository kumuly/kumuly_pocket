import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/for_you/for_you_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
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
      body: SingleChildScrollView(
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
            const SizedBox(
              height: kSpacing5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing1 * 1.5),
              child: state.selectedTab == 1
                  ? PromosGrid(state.promos)
                  : Container(),
            ),
            const SizedBox(
              height: kSpacing4,
            ),
          ],
        ),
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

class PromosGrid extends StatelessWidget {
  const PromosGrid(this.promos, {Key? key}) : super(key: key);

  final List<Promo> promos;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: kSpacing5,
      crossAxisSpacing: kSpacing3,
      childAspectRatio: 156 / 266,
      children: promos.map((promo) => PromoCard(promo)).toList(),
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
        Radius.circular(
          kSpacing2,
        ),
      ), // This matches the Container's border radius
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kSpacing2),
          side: BorderSide(
            color: Palette.neutral[20]!,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: kSpacing1,
            top: kSpacing1,
            right: kSpacing1,
            bottom: kSpacing1 * 1.5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 140,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(kSpacing1),
                    topRight: Radius.circular(kSpacing1),
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: promo.images[0],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      promo.merchant.name,
                      style: textTheme.caption1(
                        Palette.neutral[70],
                        FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerRight,
                    highlightColor: Colors.transparent,
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border_outlined),
                    selectedIcon: const Icon(Icons.favorite),
                    color: Palette.neutral[50],
                    iconSize: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: kSpacing1,
              ),
              Row(
                children: [
                  promo.discountedPrice == promo.originalPrice
                      ? Container()
                      : Text(
                          promo.originalPrice.toString(),
                          style: textTheme
                              .display1(
                                Palette.neutral[70],
                                FontWeight.w400,
                              )
                              .copyWith(
                                decoration: TextDecoration.lineThrough,
                              ),
                        ),
                  Text(
                    promo.discountedPrice.floor() == promo.discountedPrice
                        ? promo.discountedPrice.toStringAsFixed(0)
                        : promo.discountedPrice.toStringAsFixed(2),
                    style: textTheme.display5(
                      Palette.neutral[120],
                      FontWeight.w700,
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
              const SizedBox(
                height: kSpacing1,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: '${promo.tag}・',
                    style: textTheme.body1(
                      Palette.neutral[60],
                      FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: promo.headline,
                        style: textTheme.body1(
                          Palette.neutral[60],
                          FontWeight.w400,
                          wordSpacing: 0,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
