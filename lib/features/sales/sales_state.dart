import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/view_models/payment.dart';

@immutable
class SalesState extends Equatable {
  const SalesState({
    this.balanceSat,
    this.payments,
  });

  final int? balanceSat;
  final List<Payment>? payments;

  SalesState copyWith({
    int? balanceInSat,
    List<Payment>? payments,
  }) {
    return SalesState(
      balanceSat: balanceSat ?? balanceSat,
      payments: payments ?? this.payments,
    );
  }

  @override
  List<Object?> get props => [balanceSat, payments];
}
