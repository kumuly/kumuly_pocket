import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/view_models/promo.dart';

@immutable
class PromoCodeState extends Equatable {
  const PromoCodeState({
    this.paymentHash,
    this.isRedeemed = false,
    this.isExpired = false,
  });

  final String? paymentHash;
  final bool? isRedeemed;
  final bool? isExpired;

  @override
  List<Object?> get props => [
        paymentHash,
        isRedeemed,
        isExpired,
      ];
}
