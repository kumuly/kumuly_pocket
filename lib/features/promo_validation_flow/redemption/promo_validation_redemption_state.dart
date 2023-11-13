import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class PromoValidationRedemptionState extends Equatable {
  const PromoValidationRedemptionState({
    this.isValidated = false,
    this.isCancelled = false,
    this.amountSat,
  });

  final bool isValidated;
  final bool isCancelled;
  final int? amountSat;

  PromoValidationRedemptionState copyWith({
    bool? isValidated,
    bool? isCancelled,
    int? amountSat,
  }) {
    return PromoValidationRedemptionState(
      isValidated: isValidated ?? this.isValidated,
      isCancelled: isCancelled ?? this.isCancelled,
      amountSat: amountSat ?? this.amountSat,
    );
  }

  @override
  List<Object?> get props => [
        isValidated,
        isCancelled,
        amountSat,
      ];
}
