import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/view_models/invoice.dart';

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
  final Invoice? invoice;

  CashierGenerationState copyWith({
    double? localCurrencyAmount,
    int? amountSat,
    String? description,
    Invoice? invoice,
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
    if (invoice == null) {
      return '';
    } else {
      final bolt11 = invoice!.bolt11;
      return '${bolt11.substring(0, 8)}...${bolt11.substring(bolt11.length - 8)}';
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
