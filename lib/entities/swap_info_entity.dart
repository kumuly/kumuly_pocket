import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class SwapInfoEntity extends Equatable {
  const SwapInfoEntity(
    this.bitcoinAddress,
    this.maxAmount,
    this.minAmount,
    this.proportionalChannelOpeningFee,
    this.feeExpiry,
  );

  final String bitcoinAddress;
  final int maxAmount;
  final int minAmount;
  final int? proportionalChannelOpeningFee; // in ppm
  final String? feeExpiry;

  @override
  List<Object?> get props => [
        bitcoinAddress,
        maxAmount,
        minAmount,
        proportionalChannelOpeningFee,
        feeExpiry,
      ];
}
