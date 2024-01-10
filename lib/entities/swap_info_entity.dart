import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class SwapInfoEntity extends Equatable {
  const SwapInfoEntity(
    this.bitcoinAddress,
    this.maxAmount,
    this.minAmount,
    this.paymentHash,
    this.paidAmountSat,
  );

  final String bitcoinAddress;
  final int maxAmount;
  final int minAmount;
  final String? paymentHash;
  final int? paidAmountSat;

  @override
  List<Object?> get props => [
        bitcoinAddress,
        maxAmount,
        minAmount,
        paymentHash,
        paidAmountSat,
      ];
}
