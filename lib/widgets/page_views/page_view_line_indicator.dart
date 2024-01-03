import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount * 2 - 1,
        (index) {
          // Check if it's a line or a spacer
          if (index % 2 == 0) {
            int pageIndex = index ~/ 2;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: currentPage == pageIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.3),
                ),
              ),
            );
          } else {
            // Spacer
            return const SizedBox(width: kSpacing1);
          }
        },
      ),
    );
  }
}
