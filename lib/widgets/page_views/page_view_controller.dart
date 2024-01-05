import 'package:flutter/material.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'page_view_controller.g.dart';

@Riverpod(keepAlive: false)
class PageViewController extends _$PageViewController {
  @override
  PageViewState build(String? id) {
    final pageController = PageController();
    pageController.addListener(_onPageChanged);
    ref.onDispose(() => pageController.dispose());

    return PageViewState(
      pageController: pageController,
      currentPage: 0,
    );
  }

  void _onPageChanged() {
    state = state.copyWith(
      currentPage: state.pageController.page?.round() ?? 0,
    );
  }

  // When we also want to add buttons instead of swiping
  void nextPage() {
    state.pageController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  // When we also want to add buttons instead of swiping
  void previousPage() {
    state.pageController.previousPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  void jumpToPage(int page) {
    state.pageController.jumpToPage(page);
  }
}
