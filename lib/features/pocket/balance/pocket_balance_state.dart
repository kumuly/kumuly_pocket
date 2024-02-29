import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class PocketBalanceState extends Equatable {
  // Todo: add on-chain balance
  const PocketBalanceState({
    this.balanceSat,
    this.hasPendingBalance = false,
  });

  final int? balanceSat;
  final bool hasPendingBalance;

  PocketBalanceState copyWith({
    int? balanceSat,
    bool? hasPendingBalance,
  }) {
    return PocketBalanceState(
      balanceSat: balanceSat ?? this.balanceSat,
      hasPendingBalance: hasPendingBalance ?? this.hasPendingBalance,
    );
  }

  @override
  List<Object?> get props => [
        balanceSat,
        hasPendingBalance,
      ];
}
