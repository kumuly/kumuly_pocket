import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class PageViewIndicator extends ConsumerWidget {
  final int pageCount;
  final Color currentPageColor;
  final Color hiddenPageColor;
  final double currentPageSize;
  final double hiddenPageSize;

  PageViewIndicator({
    super.key,
    required this.pageCount,
    currentPageColor,
    hiddenPageColor,
    this.currentPageSize = 8.0,
    this.hiddenPageSize = 4.0,
  })  : currentPageColor = currentPageColor ?? Palette.neutral[70],
        hiddenPageColor = hiddenPageColor ?? Palette.neutral[50];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(pageViewControllerProvider).currentPage;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        return Container(
          margin: const EdgeInsets.all(4.0),
          width: currentPage == index ? currentPageSize : hiddenPageSize,
          height: currentPage == index ? currentPageSize : hiddenPageSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index ? currentPageColor : hiddenPageColor,
          ),
        );
      }),
    );
  }
}
