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
                (myPostListItem) => Column(
                  children: [
                    MyPostsListItemWidget(
                      myPostListItem,
                      key: Key(
                        myPostListItem.promoId,
                      ),
                    ),
                    const SizedBox(
                      height: kSpacing3,
                    ),
                  ],
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
                myPostListItem.isFinished
                    ? Text(
                        'Finished'.toUpperCase(),
                        style: textTheme.caption1(
                          Palette.neutral[100],
                          FontWeight.w500,
                        ),
                      )
                    : Text(
                        '${myPostListItem.daysLeft} days left'.toUpperCase(),
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
                      myPostListItem.isFinished
                          ? Palette.neutral[60]
                          : Palette.neutral[100],
                      FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: kSpacing5,
                ),
                // Image container with overlay if finished
                Stack(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kSpacing1 * 1.5),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: myPostListItem.image,
                    ),
                    if (myPostListItem.isFinished) // Check if promo is finished
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.5), // Semi-transparent overlay
                          borderRadius: BorderRadius.circular(kSpacing1 * 1.5),
                        ),
                      ),
                  ],
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
                  myPostListItem.isFinished
                      ? Palette.neutral[40]
                      : Palette.neutral[60],
                  FontWeight.w700,
                ),
                children: [
                  TextSpan(
                    text: ' ・ ${myPostListItem.headline}',
                    style: textTheme.body3(
                      myPostListItem.isFinished
                          ? Palette.neutral[40]
                          : Palette.neutral[60],
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
                    color: myPostListItem.isFinished
                        ? Palette.neutral[30]
                        : Palette.neutral[50],
                    size: 16,
                  ),
                  value: myPostListItem.views,
                  labelColor: myPostListItem.isFinished
                      ? Palette.neutral[40]
                      : Palette.neutral[70],
                ),
                MetricIconAndValue(
                  icon: DynamicIcon(
                    icon: Icons.timelapse,
                    color: myPostListItem.isFinished
                        ? Palette.neutral[30]
                        : Palette.neutral[50],
                    size: 16,
                  ),
                  value: myPostListItem.toRedeem,
                  labelColor: myPostListItem.isFinished
                      ? Palette.neutral[40]
                      : Palette.neutral[70],
                ),
                MetricIconAndValue(
                  icon: DynamicIcon(
                    icon: Icons.how_to_reg,
                    color: myPostListItem.isFinished
                        ? Palette.neutral[30]
                        : Palette.neutral[50],
                    size: 16,
                  ),
                  value: myPostListItem.redeemed,
                  labelColor: myPostListItem.isFinished
                      ? Palette.neutral[40]
                      : Palette.neutral[70],
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
  MetricIconAndValue({
    super.key,
    required this.icon,
    required this.value,
    borderColor,
    labelColor,
  })  : borderColor = borderColor ?? Palette.neutral[20],
        labelColor = labelColor ?? Palette.neutral[70];

  final DynamicIcon icon;
  final String value;
  final Color borderColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 72,
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
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
              labelColor,
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
