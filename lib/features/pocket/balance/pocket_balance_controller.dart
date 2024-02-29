import 'package:kumuly_pocket/features/pocket/balance/pocket_balance_state.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pocket_balance_controller.g.dart';

@Riverpod(keepAlive: true)
class PocketBalanceController extends _$PocketBalanceController {
  @override
  Future<PocketBalanceState> build() async {
    //ref.invalidate(spendableBalanceSatProvider); // and check which stream to listen to to update the balance automatically
    final breezSdk = ref.watch(breezeSdkLightningNodeServiceProvider);

    final channelsBalanceStream =
        breezSdk.channelsBalanceSatStream.listen((balance) {
      print('channelsBalanceSatStream: $balance');
      update((previousState) => previousState.copyWith(
            balanceSat: balance,
          ));
    });
    final onChainBalanceStream =
        breezSdk.onChainBalanceSatStream.listen((balance) {
      print('onChainBalanceSatStream: $balance');
      update((previousState) => previousState.copyWith(
            hasPendingBalance: balance > 0,
          ));
    });

    ref.onDispose(() {
      channelsBalanceStream.cancel();
      onChainBalanceStream.cancel();
    });

    return PocketBalanceState(balanceSat: await breezSdk.spendableBalanceSat);
  }

  Future<void> refresh() async {
    final breezSdk = ref.watch(breezeSdkLightningNodeServiceProvider);
    final onChainBalanceSat = await breezSdk.onChainBalanceSat;

    await (breezSdk as BreezSdkLightningNodeService).printNodeInfo();
    await breezSdk.swapInsInProgress;

    update((previousState) => previousState.copyWith(
          balanceSat: ref.refresh(spendableBalanceSatProvider).asData?.value,
          hasPendingBalance: onChainBalanceSat > 0,
        ));
  }
}
