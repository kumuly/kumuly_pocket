import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class PocketBalanceState extends Equatable {
  // Todo: add on-chain balance
  const PocketBalanceState({
    this.balanceSat,
  });

  final int? balanceSat;

  PocketBalanceState copyWith({
    int? balanceInSat,
  }) {
    return PocketBalanceState(
      balanceSat: balanceInSat ?? balanceSat,
    );
  }

  @override
  List<Object?> get props => [
        balanceSat,
      ];
}
