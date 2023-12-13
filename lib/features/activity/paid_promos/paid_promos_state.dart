import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/view_models/promo.dart';

@immutable
class PaidPromosState extends Equatable {
  const PaidPromosState({
    this.isOnActiveTab = true,
    this.activePromos = const [],
    this.redeemedPromos = const [],
  });

  final bool isOnActiveTab;
  final List<Promo> activePromos;
  final List<Promo> redeemedPromos;

  PaidPromosState copyWith({
    bool? isOnActiveTab,
    List<Promo>? activePromos,
    List<Promo>? redeemedPromos,
  }) {
    return PaidPromosState(
      isOnActiveTab: isOnActiveTab ?? this.isOnActiveTab,
      activePromos: activePromos ?? this.activePromos,
      redeemedPromos: redeemedPromos ?? this.redeemedPromos,
    );
  }

  @override
  List<Object?> get props => [
        isOnActiveTab,
        activePromos,
        redeemedPromos,
      ];
}
