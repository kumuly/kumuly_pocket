import 'package:kumuly_pocket/features/pocket/balance/pocket_balance_state.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pocket_balance_controller.g.dart';

@riverpod
class PocketBalanceController extends _$PocketBalanceController {
  @override
  PocketBalanceState build() {
    //ref.invalidate(spendableBalanceSatProvider); // and check which stream to listen to to update the balance automatically

    return PocketBalanceState(
      balanceSat: ref.watch(spendableBalanceSatProvider).asData?.value,
    );
  }

  Future<void> refreshBalance() async {
    state = state.copyWith(
      balanceInSat: ref.refresh(spendableBalanceSatProvider).asData?.value,
    );
  }
}
