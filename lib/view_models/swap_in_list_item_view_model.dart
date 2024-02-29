import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/entities/swap_in_entity.dart';

@immutable
class SwapInListItemViewModel extends Equatable {
  final int amountSat;

  const SwapInListItemViewModel({
    required this.amountSat,
  });

  factory SwapInListItemViewModel.fromEntity(SwapInEntity entity) {
    return SwapInListItemViewModel(
      amountSat: entity.paidAmountSat ??
          entity.confirmedAmountSat ??
          entity.unconfirmedAmountSat ??
          0,
    );
  }

  @override
  List<Object?> get props => [
        amountSat,
      ];
}
