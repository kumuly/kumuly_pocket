import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/view_models/promo.dart';

@immutable
class PromoDetailsState extends Equatable {
  const PromoDetailsState({
    required this.promo,
    this.amountSat,
  });

  final Promo promo;
  final int? amountSat;

  PromoDetailsState copyWith({
    Promo? promo,
    int? amountSat,
  }) {
    return PromoDetailsState(
      promo: promo ?? this.promo,
      amountSat: amountSat ?? this.amountSat,
    );
  }

  @override
  List<Object?> get props => [
        promo,
        amountSat,
      ];
}
