import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/enums/payment_type.dart';

@immutable
class PaymentRequestEntity extends Equatable {
  const PaymentRequestEntity({
    required this.type,
    required this.amountSat,
    this.maxAmountSat,
    this.description,
    this.nodeId,
    this.bitcoinAddress,
  });

  final PaymentRequestType type;
  final int amountSat;
  final int? maxAmountSat;
  final String? description;
  final String? nodeId;
  final String? bitcoinAddress;

  @override
  List<Object?> get props => [
        type,
        amountSat,
        maxAmountSat,
        description,
        nodeId,
        bitcoinAddress,
      ];
}
