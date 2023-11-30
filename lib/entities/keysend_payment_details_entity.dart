import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class KeysendPaymentDetailsEntity extends Equatable {
  const KeysendPaymentDetailsEntity({
    required this.paymentHash,
    required this.paymentTime,
  });

  final String paymentHash;
  final int paymentTime;

  @override
  List<Object?> get props => [
        paymentHash,
        paymentTime,
      ];
}
