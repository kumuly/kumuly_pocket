import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/view_models/promo.dart';

@immutable
class ForYouState extends Equatable {
  const ForYouState({
    required this.tabs,
    required this.selectedTab,
    required this.promos,
  });

  final List<String> tabs;
  final int selectedTab;
  final List<Promo> promos; // Todo: change to product model

  ForYouState copyWith({
    List<String>? tabs,
    int? selectedTab,
    List<Promo>? promos,
  }) {
    return ForYouState(
      tabs: tabs ?? this.tabs,
      selectedTab: selectedTab ?? this.selectedTab,
      promos: promos ?? this.promos,
    );
  }

  @override
  List<Object?> get props => [
        tabs,
        selectedTab,
        promos,
      ];
}
