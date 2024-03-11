import 'package:kumuly_pocket/features/pocket/balance/pocket_balance_state.dart';
import 'package:kumuly_pocket/services/lightning_node/impl/breez_sdk_lightning_node_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pocket_balance_controller.g.dart';

@riverpod
class PocketBalanceController extends _$PocketBalanceController {
  @override
  FutureOr<PocketBalanceState> build() async {
    final breezSdk = ref.watch(breezeSdkLightningNodeServiceProvider);

    await (breezSdk as BreezSdkLightningNodeService).printNodeInfo();

    final channelsBalanceStream =
        breezSdk.channelsBalanceSatStream.listen((balance) async {
      update((previousState) async => previousState.balanceSat == balance
          ? previousState
          : previousState.copyWith(
              balanceSat: balance,
            ));
    });
    final onChainBalanceStream =
        breezSdk.onChainBalanceSatStream.listen((balance) async {
      update((previousState) async =>
          previousState.hasPendingBalance != balance > 0
              ? previousState.copyWith(
                  balanceSat: await breezSdk.spendableBalanceSat,
                  hasPendingBalance: await breezSdk.onChainBalanceSat > 0,
                )
              : previousState);
    });

    ref.onDispose(() {
      channelsBalanceStream.cancel();
      onChainBalanceStream.cancel();
    });

    return PocketBalanceState(
      balanceSat: await breezSdk.spendableBalanceSat,
      hasPendingBalance: await breezSdk.onChainBalanceSat > 0,
    );
  }

  Future<void> drainOnChainFunds() async {
    final breezSdk = ref.watch(breezeSdkLightningNodeServiceProvider);
    await breezSdk.drainOnChainFunds();
  }
}
