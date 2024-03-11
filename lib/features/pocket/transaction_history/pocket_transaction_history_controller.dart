import 'package:kumuly_pocket/features/pocket/transaction_history/pocket_transaction_history_state.dart';
import 'package:kumuly_pocket/services/lightning_node/impl/breez_sdk_lightning_node_service.dart';
import 'package:kumuly_pocket/view_models/transaction_list_item_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pocket_transaction_history_controller.g.dart';

@riverpod
class PocketTransactionHistoryController
    extends _$PocketTransactionHistoryController {
  @override
  FutureOr<PocketTransactionHistoryState> build(int transactionsLimit) async {
    final transactions =
        await ref.read(breezeSdkLightningNodeServiceProvider).getPaymentHistory(
              limit: transactionsLimit,
            );

    return PocketTransactionHistoryState(
      transactionsLimit: transactionsLimit,
      transactions: transactions
          .map((entity) =>
              TransactionListItemViewModel.fromTransactionEntity(entity))
          .toList(),
      transactionsOffset: transactions.length,
      hasMoreTransactions: transactions.length == transactionsLimit,
    );
  }

  Future<void> fetchTransactions({bool refresh = false}) async {
    await update((state) async {
      // Fetch transactions
      final transactionEntities = await ref
          .read(breezeSdkLightningNodeServiceProvider)
          .getPaymentHistory(
            offset: refresh ? null : state.transactionsOffset,
            limit: state.transactionsLimit,
          );

      // Update state
      return state.copyWith(
        transactions: refresh
            ? transactionEntities
                .map((entity) =>
                    TransactionListItemViewModel.fromTransactionEntity(entity))
                .toList()
            : [
                ...state.transactions,
                ...transactionEntities.map((entity) =>
                    TransactionListItemViewModel.fromTransactionEntity(entity)),
              ],
        transactionsOffset:
            state.transactionsOffset + transactionEntities.length,
        hasMoreTransactions:
            transactionEntities.length == state.transactionsLimit,
      );
    });
  }
}
