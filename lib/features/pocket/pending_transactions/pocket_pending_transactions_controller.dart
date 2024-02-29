import 'package:kumuly_pocket/entities/swap_in_entity.dart';
import 'package:kumuly_pocket/features/pocket/pending_transactions/pocket_pending_transactions_state.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/view_models/swap_in_list_item_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pocket_pending_transactions_controller.g.dart';

@Riverpod(keepAlive: true)
class PocketPendingTransactionsController
    extends _$PocketPendingTransactionsController {
  @override
  Future<PocketPendingTransactionsState> build() async {
    final breezSdk = ref.watch(breezeSdkLightningNodeServiceProvider);
    final (onChainBalanceSat, swapInsInProgress) = await _fetchData();

    final onChainBalanceStream =
        breezSdk.onChainBalanceSatStream.listen((balance) {
      update((previousState) => previousState.copyWith(
            spendableOnChainBalanceSat: balance,
          ));
    });

    ref.onDispose(() {
      onChainBalanceStream.cancel();
    });

    return PocketPendingTransactionsState(
      spendableOnChainBalanceSat: onChainBalanceSat,
      swapInTransactions: swapInsInProgress
          .map((entity) => SwapInListItemViewModel.fromEntity(entity))
          .toList(),
    );
  }

  Future<void> refresh() async {
    final (balance, swapInsInProgress) = await _fetchData();
    update((previousState) => previousState.copyWith(
          spendableOnChainBalanceSat: balance,
          swapInTransactions: swapInsInProgress
              .map((entity) => SwapInListItemViewModel.fromEntity(entity))
              .toList(),
        ));
  }

  Future<(int, List<SwapInEntity>)> _fetchData() async {
    final breezSdk = ref.watch(breezeSdkLightningNodeServiceProvider);
    late int onChainBalanceSat;
    late List<SwapInEntity> swapInsInProgress;

    await Future.wait(
      [
        breezSdk.onChainBalanceSat.then((value) => onChainBalanceSat = value),
        breezSdk.swapInsInProgress.then((value) => swapInsInProgress = value),
      ],
    );
    return (onChainBalanceSat, swapInsInProgress);
  }
}
