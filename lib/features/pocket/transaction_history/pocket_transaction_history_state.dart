import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/view_models/transaction_list_item_view_model.dart';

@immutable
class PocketTransactionHistoryState extends Equatable {
  const PocketTransactionHistoryState({
    this.transactions = const [],
    this.transactionsOffset = 0,
    required this.transactionsLimit,
    this.hasMoreTransactions = true,
  });

  final List<TransactionListItemViewModel> transactions;
  final int transactionsOffset;
  final int transactionsLimit;
  final bool hasMoreTransactions;

  PocketTransactionHistoryState copyWith({
    List<TransactionListItemViewModel>? transactions,
    int? transactionsOffset,
    int? transactionsLimit,
    bool? hasMoreTransactions,
  }) {
    return PocketTransactionHistoryState(
      transactions: transactions ?? this.transactions,
      transactionsOffset: transactionsOffset ?? this.transactionsOffset,
      transactionsLimit: transactionsLimit ?? this.transactionsLimit,
      hasMoreTransactions: hasMoreTransactions ?? this.hasMoreTransactions,
    );
  }

  @override
  List<Object?> get props => [
        transactions,
        transactionsOffset,
        transactionsLimit,
        hasMoreTransactions,
      ];
}
