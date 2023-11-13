import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/view_models/promo.dart';

@immutable
class PromoValidationScannerState extends Equatable {
  const PromoValidationScannerState({
    this.promoCode,
    this.promo,
  });

  final String? promoCode;
  final Promo? promo;

  PromoValidationScannerState copyWith({
    String? promoCode,
    Promo? promo,
  }) {
    return PromoValidationScannerState(
      promoCode: promoCode ?? this.promoCode,
      promo: promo ?? this.promo,
    );
  }

  @override
  List<Object?> get props => [
        promoCode,
        promo,
      ];
}
