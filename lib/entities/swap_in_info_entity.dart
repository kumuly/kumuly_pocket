import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class SwapInInfoEntity extends Equatable {
  const SwapInInfoEntity(
    this.bitcoinAddress,
    this.maxAmount,
    this.minAmount,
    this.feeEstimate,
    this.feeExpiryTimestamp,
  );

  final String bitcoinAddress;
  final int maxAmount;
  final int minAmount;
  final int? feeEstimate;
  final int? feeExpiryTimestamp;

  @override
  List<Object?> get props => [
        bitcoinAddress,
        maxAmount,
        minAmount,
        feeEstimate,
        feeExpiryTimestamp,
      ];
}
