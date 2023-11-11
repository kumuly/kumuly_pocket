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

  /// Get the 8 first and 8 last characters of the invoice with ellipsis in the
  ///   middle for display purposes.
  String get partialInvoice {
    if (invoice == null || invoice!.isEmpty) {
      return '';
    } else {
      return '${invoice!.substring(0, 8)}...${invoice!.substring(invoice!.length - 8)}';
    }
  }

  String formattedLocalCurrencyAmount(int decimals) {
    if (localCurrencyAmount == null) {
      return '';
    } else {
      final fixed = localCurrencyAmount!.toStringAsFixed(decimals);
      final [integerString, decimalsString] = fixed.split('.');
      if (int.parse(decimalsString) == 0) {
        return integerString;
      } else {
        return fixed;
      }
    }
  }

  @override
  List<Object?> get props => [
        localCurrencyAmount,
        amountSat,
        description,
        invoice,
      ];
}
