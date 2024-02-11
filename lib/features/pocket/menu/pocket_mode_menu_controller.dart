import 'package:kumuly_pocket/features/pocket/menu/pocket_mode_menu_state.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/repositories/lightning_node_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pocket_mode_menu_controller.g.dart';

@riverpod
class PocketModeMenuController extends _$PocketModeMenuController {
  @override
  Future<PocketModeMenuState> build() async {
    final nodeId =
        await ref.watch(breezeSdkLightningNodeRepositoryProvider).nodeId;
    final bitcoinUnit = ref.watch(bitcoinUnitProvider);
    final localCurrency = ref.watch(localCurrencyProvider);
    final location = 'Leuven, BE';
    final isLocationEnabled = false;
    final lastSeedBackupDate = null;
    final lastStaticChannelBackupDate = null;

    return PocketModeMenuState(
      nodeId: nodeId,
      notifications: [],
      bitcoinUnit: bitcoinUnit,
      localCurrency: localCurrency,
      location: location,
      isLocationEnabled: isLocationEnabled,
      version: '0.0.0',
      lastSeedBackupDate: lastSeedBackupDate,
      lastStaticChannelBackupDate: lastStaticChannelBackupDate,
    );
  }
}
