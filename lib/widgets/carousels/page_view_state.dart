import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class PageViewState extends Equatable {
  final PageController pageController;
  final int currentPage;

  const PageViewState({
    required this.pageController,
    this.currentPage = 0,
  });

  PageViewState copyWith({
    PageController? pageController,
    int? currentPage,
  }) {
    return PageViewState(
      pageController: pageController ?? this.pageController,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
        pageController,
        currentPage,
      ];
}
