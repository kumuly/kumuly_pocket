import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/view_models/swap_in_list_item_view_model.dart';

@immutable
class PocketPendingTransactionsState extends Equatable {
  final int spendableOnChainBalanceSat;
  final List<SwapInListItemViewModel> swapInTransactions;

  const PocketPendingTransactionsState({
    this.spendableOnChainBalanceSat = 0,
    this.swapInTransactions = const [],
  });

  PocketPendingTransactionsState copyWith({
    int? spendableOnChainBalanceSat,
    List<SwapInListItemViewModel>? swapInTransactions,
  }) {
    return PocketPendingTransactionsState(
      spendableOnChainBalanceSat:
          spendableOnChainBalanceSat ?? this.spendableOnChainBalanceSat,
      swapInTransactions: swapInTransactions ?? this.swapInTransactions,
    );
  }

  @override
  List<Object?> get props => [
        spendableOnChainBalanceSat,
        swapInTransactions,
      ];
}
