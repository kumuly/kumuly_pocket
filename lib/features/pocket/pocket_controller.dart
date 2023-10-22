import 'package:kumuly_pocket/features/pocket/pocket_state.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pocket_controller.g.dart';

@riverpod
class PocketController extends _$PocketController {
  @override
  PocketState build() {
    return PocketState(
      balanceInSat: ref.watch(spendableBalanceSatProvider).asData?.value,
      payments: null,
    );
  }
}
