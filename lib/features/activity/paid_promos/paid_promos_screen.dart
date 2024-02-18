import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/activity/paid_promos/paid_promos_controller.dart';
import 'package:kumuly_pocket/router/app_router.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
import 'package:kumuly_pocket/widgets/containers/ripped_paper_container.dart';
import 'package:kumuly_pocket/widgets/tabs/chip_tab.dart';

class PaidPromosScreen extends ConsumerWidget {
  const PaidPromosScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final copy = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final notifier = ref.read(paidPromosControllerProvider.notifier);
    final state = ref.watch(paidPromosControllerProvider);

    return Scaffold(
      backgroundColor: Palette.neutral[20],
      appBar: AppBar(
        title: Text(
          'Paid promos',
          style: textTheme.display4(
            Palette.neutral[100]!,
            FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Palette.neutral[100]!,
        iconTheme: IconThemeData(color: Palette.neutral[100]!),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: kSpacing1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChipTab(
                  label: state.isOnActiveTab ? 'Active ✨' : 'Active',
                  isSelected: state.isOnActiveTab,
                  onPressed: () => notifier.onTabSelectHandler(true),
                ),
                const SizedBox(
                  width: kSpacing2,
                ),
                ChipTab(
                  label: !state.isOnActiveTab ? 'Redeemed ✅' : 'Redeemed',
                  isSelected: !state.isOnActiveTab,
                  onPressed: () => notifier.onTabSelectHandler(false),
                ),
              ],
            ),
            const SizedBox(
              height: kSpacing5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing1 * 1.5),
              child: state.isOnActiveTab
                  ? ActivePromosGrid(state.activePromos)
                  : RedeemedPromosGrid(state.redeemedPromos),
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

class ActivePromosGrid extends StatelessWidget {
  const ActivePromosGrid(this.activePromos, {Key? key}) : super(key: key);

  final List<Promo> activePromos;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: kSpacing5,
      crossAxisSpacing: kSpacing3,
      childAspectRatio: 156 / 292,
      children: activePromos.map((promo) => ActivePromoCard(promo)).toList(),
    );
  }
}

class RedeemedPromosGrid extends StatelessWidget {
  const RedeemedPromosGrid(this.redeemedPromos, {Key? key}) : super(key: key);

  final List<Promo> redeemedPromos;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: kSpacing5,
      crossAxisSpacing: kSpacing3,
      childAspectRatio: 156 / 292,
      children:
          redeemedPromos.map((promo) => RedeemedPromoCard(promo)).toList(),
    );
  }
}

class ActivePromoCard extends StatelessWidget {
  const ActivePromoCard(this.promo, {Key? key}) : super(key: key);

  final Promo promo;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);

    return InkWell(
      onTap: () {
        router.pushNamed(
          AppRoute.promoCode.name,
          pathParameters: {'id': promo.id!},
          extra: promo,
        );
      },
      borderRadius: const BorderRadius.all(
        Radius.circular(
          kSpacing2,
        ),
      ), // This matches the Container's border radius
      child: RippedPaperContainer(
        padding: const EdgeInsets.only(
          left: kSpacing1,
          top: kSpacing1,
          right: kSpacing1,
          bottom: kSpacing1 * 1.5,
        ),
        topBorderRadius: kSpacing2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promo.tag,
                        style: textTheme.display3(
                          Palette.neutral[60],
                          FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: kSpacing1 / 2,
                      ),
                      Text(
                        promo.headline,
                        style: textTheme.body2(
                          Palette.neutral[60],
                          FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promo.daysLeft.toString(),
                        style: textTheme.display3(
                          Palette.neutral[80],
                          FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        'Days left',
                        style: textTheme.caption1(
                          Palette.success[50],
                          FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
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

class RedeemedPromoCard extends StatelessWidget {
  const RedeemedPromoCard(this.promo, {super.key});

  final Promo promo;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
