import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class ReceiveSatsReceptionState extends Equatable {
  const ReceiveSatsReceptionState({
    this.isPaid = false,
    this.isSwapInProgress = false,
  });

  final bool isPaid;
  final bool isSwapInProgress;

  ReceiveSatsReceptionState copyWith({
    bool? isPaid,
    bool? isSwapInProgress,
  }) {
    return ReceiveSatsReceptionState(
      isPaid: isPaid ?? this.isPaid,
      isSwapInProgress: isSwapInProgress ?? this.isSwapInProgress,
    );
  }

  @override
  List<Object?> get props => [
        isPaid,
        isSwapInProgress,
      ];
}
