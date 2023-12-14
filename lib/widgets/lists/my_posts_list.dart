import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/my_posts_list_item.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/lists/lazy_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyPostsList extends StatelessWidget {
  const MyPostsList({
    super.key,
    required this.myPostsListItems,
    required this.loadMyPostsListItems,
    required this.limit,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingError = false,
  });

  final List<MyPostsListItem> myPostsListItems;
  final Future<void> Function({bool refresh}) loadMyPostsListItems;
  final int limit;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LazyList(
          neverScrollable: true,
          items: myPostsListItems
              .map(
                (myPostListItem) => MyPostsListItemWidget(
                  myPostListItem,
                  key: Key(
                    myPostListItem.promoId,
                  ),
                ),
              )
              .toList(),
          loadItems: loadMyPostsListItems,
          limit: limit,
          hasMore: hasMore,
          isLoading: isLoading,
          isLoadingError: isLoadingError,
          emptyIndicator: null, // TODO: implement emptyIndicator
          errorIndicator: null, // TODO: implement errorIndicator
          noMoreItemsIndicator: null, // TODO: implement noMoreItemsIndicator
        ),
      ],
    );
  }
}

class MyPostsListItemWidget extends ConsumerWidget {
  const MyPostsListItemWidget(this.myPostListItem, {required super.key});

  final MyPostsListItem myPostListItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kSpacing3),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(kSpacing3),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${myPostListItem.daysLeft} days left',
                  style: textTheme.caption1(
                    Palette.success[50],
                    FontWeight.w500,
                  ),
                ),
                Text(
                  myPostListItem.createdAtDate,
                  style: textTheme.caption1(
                    Palette.neutral[60],
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: kSpacing3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    myPostListItem.title,
                    style: textTheme.display5(
                      Palette.neutral[400],
                      FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: kSpacing5,
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kSpacing3),
                  ),
                  child: myPostListItem.image,
                ),
              ],
            ),
            const SizedBox(
              height: kSpacing2,
            ),
            RichText(
              text: TextSpan(
                text: myPostListItem.tag,
                style: textTheme.body3(
                  Palette.neutral[60],
                  FontWeight.w700,
                ),
                children: [
                  TextSpan(
                    text: ' ・ ${myPostListItem.headline}',
                    style: textTheme.body3(
                      Palette.neutral[60],
                      FontWeight.w400,
                    ),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: kSpacing3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MetricIconAndValue(
                  icon: DynamicIcon(
                    icon: Icons.visibility,
                    color: Palette.neutral[50],
                    size: 16,
                  ),
                  value: myPostListItem.views,
                ),
                MetricIconAndValue(
                  icon: DynamicIcon(
                    icon: Icons.timelapse,
                    color: Palette.neutral[50],
                    size: 16,
                  ),
                  value: myPostListItem.toRedeem,
                ),
                MetricIconAndValue(
                  icon: DynamicIcon(
                    icon: Icons.how_to_reg,
                    color: Palette.neutral[50],
                    size: 16,
                  ),
                  value: myPostListItem.redeemed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MetricIconAndValue extends StatelessWidget {
  const MetricIconAndValue({
    super.key,
    required this.icon,
    required this.value,
  });

  final DynamicIcon icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 72,
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(
          color: Palette.neutral[20]!,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(kSpacing1 * 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(
            height: kSpacing1 / 2,
          ),
          Text(
            value,
            style: textTheme.caption1(
              Palette.neutral[70],
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
