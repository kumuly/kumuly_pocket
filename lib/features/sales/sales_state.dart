import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class SalesState extends Equatable {
  const SalesState({
    this.balanceSat,
    this.sales,
  });

  final int? balanceSat;
  final List<void>? sales;

  SalesState copyWith({
    int? balanceInSat,
    List<void>? sales,
  }) {
    return SalesState(
      balanceSat: balanceSat ?? balanceSat,
      sales: sales ?? this.sales,
    );
  }

  @override
  List<Object?> get props => [balanceSat, sales];
}
