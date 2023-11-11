import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class CashierGenerationState extends Equatable {
  const CashierGenerationState({
    this.localCurrencyAmount,
    this.amountSat,
    this.description,
    this.invoice,
  });

  final double? localCurrencyAmount;
  final int? amountSat;
  final String? description;
  final String? invoice;

  CashierGenerationState copyWith({
    double? localCurrencyAmount,
    int? amountSat,
    String? description,
    String? invoice,
  }) {
    return CashierGenerationState(
      localCurrencyAmount: localCurrencyAmount ?? this.localCurrencyAmount,
      amountSat: amountSat ?? this.amountSat,
      description: description ?? this.description,
      invoice: invoice ?? this.invoice,
    );
  }

  @override
  List<Object?> get props => [
        localCurrencyAmount,
        amountSat,
        description,
        invoice,
      ];
}
