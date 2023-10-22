import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/view_models/payment.dart';

@immutable
class PocketState extends Equatable {
  // Todo: add on-chain balance
  const PocketState({
    this.balanceInSat,
    this.payments,
  });

  final int? balanceInSat;
  final List<Payment>? payments;

  PocketState copyWith({
    int? balanceInSat,
    List<Payment>? payments,
  }) {
    return PocketState(
      balanceInSat: balanceInSat ?? this.balanceInSat,
      payments: payments ?? this.payments,
    );
  }

  int? get balanceInBtc =>
      balanceInSat != null ? balanceInSat! ~/ 100000000 : null;

  @override
  List<Object?> get props => [balanceInSat, payments];
}
