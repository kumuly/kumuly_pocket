import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ForYouState extends Equatable {
  const ForYouState({
    required this.tabs,
    required this.selectedTab,
  });

  final List<String> tabs;
  final int selectedTab;
  //final List<Product> products;

  ForYouState copyWith({
    List<String>? tabs,
    int? selectedTab,
  }) {
    return ForYouState(
      tabs: tabs ?? this.tabs,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object?> get props => [
        tabs,
        selectedTab,
      ];
}
