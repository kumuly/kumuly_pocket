import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/view_models/promo.dart';

@immutable
class PromoDetailsState extends Equatable {
  const PromoDetailsState({
    required this.promo,
    this.amountSat,
    this.priceUpdatedError = false,
    this.paymentErrorMessage,
  });

  final Promo promo;
  final int? amountSat;
  final bool priceUpdatedError;
  final String? paymentErrorMessage;

  PromoDetailsState copyWith({
    Promo? promo,
    int? amountSat,
    bool? priceUpdatedError,
    String? paymentErrorMessage,
  }) {
    return PromoDetailsState(
      promo: promo ?? this.promo,
      amountSat: amountSat ?? this.amountSat,
      priceUpdatedError: priceUpdatedError ?? this.priceUpdatedError,
      paymentErrorMessage: paymentErrorMessage ?? this.paymentErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        promo,
        amountSat,
        priceUpdatedError,
        paymentErrorMessage,
      ];
}
