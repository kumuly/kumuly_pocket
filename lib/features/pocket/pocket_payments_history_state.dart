import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/view_models/payment.dart';

@immutable
class PocketPaymentsHistoryState extends Equatable {
  const PocketPaymentsHistoryState({
    this.payments = const [],
    this.paymentsOffset = 0,
    required this.paymentsLimit,
    this.hasMorePayments = true,
  });

  final List<Payment> payments;
  final int paymentsOffset;
  final int paymentsLimit;
  final bool hasMorePayments;

  PocketPaymentsHistoryState copyWith({
    List<Payment>? payments,
    int? paymentsOffset,
    int? paymentsLimit,
    bool? hasMorePayments,
  }) {
    return PocketPaymentsHistoryState(
      payments: payments ?? this.payments,
      paymentsOffset: paymentsOffset ?? this.paymentsOffset,
      paymentsLimit: paymentsLimit ?? this.paymentsLimit,
      hasMorePayments: hasMorePayments ?? this.hasMorePayments,
    );
  }

  @override
  List<Object?> get props => [
        payments,
        paymentsOffset,
        paymentsLimit,
        hasMorePayments,
      ];
}
