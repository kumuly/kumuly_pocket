import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/view_models/payment_details_view_model.dart';

@immutable
class PocketPaymentDetailsState extends Equatable {
  const PocketPaymentDetailsState({
    required this.paymentDetails,
  });

  final PaymentDetailsViewModel paymentDetails;

  @override
  List<Object?> get props => [
        paymentDetails,
      ];
}
