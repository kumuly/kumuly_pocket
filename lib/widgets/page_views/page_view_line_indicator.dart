import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class PageViewLineIndicator extends ConsumerWidget {
  const PageViewLineIndicator({
    super.key,
    this.pageViewId,
    required this.pageCount,
  });

  final String? pageViewId;
  final int pageCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref
        .watch(pageViewControllerProvider(
          pageViewId,
        ))
        .currentPage;

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        width: 300,
        height: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Colors.white.withOpacity(
            currentPage == currentPage ? 1 : 0.3,
          ),
        ),
      ),
    ]);
  }
}
