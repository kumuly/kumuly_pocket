import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:lottie/lottie.dart';

class LazyList extends StatelessWidget {
  const LazyList({
    super.key,
    required this.items,
    required this.loadItems,
    required this.limit,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingError = false,
    this.loadingIndicator,
    this.emptyIndicator,
    this.errorIndicator,
    this.noMoreItemsIndicator,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.neverScrollable = false,
    this.scrollController,
  });

  final List<Widget> items; // Make sure to use keys for these items
  final Future<void> Function() loadItems;
  final int limit;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingError;
  final Widget? loadingIndicator;
  final Widget? emptyIndicator;
  final Widget? errorIndicator;
  final Widget? noMoreItemsIndicator;
  final Axis scrollDirection;
  final bool reverse;
  final bool neverScrollable;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    if (!isLoading &&
        !isLoadingError &&
        items.isEmpty &&
        emptyIndicator != null) {
      return emptyIndicator!;
    } else {
      return ListView.builder(
        controller: scrollController,
        scrollDirection: scrollDirection,
        reverse: reverse,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: neverScrollable ? const NeverScrollableScrollPhysics() : null,
        itemCount: items.length +
            (isLoading ||
                    isLoadingError && errorIndicator != null ||
                    !hasMore && noMoreItemsIndicator != null
                ? 1
                : 0),
        itemBuilder: (context, index) {
          // If we're at the end of the loaded items and it's loading, show a spinner
          if (isLoading && index == items.length) {
            return loadingIndicator;
          }

          // If we're at the end of the loaded items and there's an error, show the error message
          if (isLoadingError && index == items.length) {
            return errorIndicator;
          }

          // If we're at the last item and there are no more items to load, show the end-of-list indicator
          if (!hasMore && index == items.length) {
            return noMoreItemsIndicator;
          }

          // Load more items when we're halfway through the last page of items
          if (hasMore && !isLoading && index == items.length - limit ~/ 2) {
            loadItems();
          }

          // For indices 0 to items.length - 1, return the actual item
          return items[index];
        },
      );
    }
  }
}
