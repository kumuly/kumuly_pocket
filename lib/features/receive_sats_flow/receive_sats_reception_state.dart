import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class ReceiveSatsReceptionState extends Equatable {
  const ReceiveSatsReceptionState({
    this.isPaid = false,
    this.isSwapInProgress = false,
    this.amountSat,
    this.paymentHash,
  });

  final bool isPaid;
  final bool isSwapInProgress;
  final int? amountSat;
  final String? paymentHash;

  ReceiveSatsReceptionState copyWith({
    bool? isPaid,
    bool? isSwapInProgress,
    int? amountSat,
    String? paymentHash,
  }) {
    return ReceiveSatsReceptionState(
      isPaid: isPaid ?? this.isPaid,
      isSwapInProgress: isSwapInProgress ?? this.isSwapInProgress,
      amountSat: amountSat ?? this.amountSat,
      paymentHash: paymentHash ?? this.paymentHash,
    );
  }

  @override
  List<Object?> get props => [
        isPaid,
        isSwapInProgress,
        amountSat,
        paymentHash,
      ];
}
