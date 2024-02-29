import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class SwapInEntity extends Equatable {
  final String bitcoinAddress;
  final String paymentHash;
  final String? bolt11;
  final int? unconfirmedAmountSat;
  final int? confirmedAmountSat;
  final int? paidAmountSat;
  final List<String>? txIds;

  const SwapInEntity({
    required this.bitcoinAddress,
    required this.paymentHash,
    this.bolt11,
    this.unconfirmedAmountSat,
    this.confirmedAmountSat,
    this.paidAmountSat,
    this.txIds,
  });

  @override
  List<Object?> get props => [
        bitcoinAddress,
        paymentHash,
        bolt11,
        unconfirmedAmountSat,
        confirmedAmountSat,
        paidAmountSat,
        txIds,
      ];
}
