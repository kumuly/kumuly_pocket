import 'package:breez_sdk/breez_sdk.dart';
import 'package:kumuly_pocket/enums/app_network.dart';
import 'package:kumuly_pocket/services/account_service.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'breez_sdk_providers.g.dart';

@riverpod
class BreezSdkMap extends _$BreezSdkMap {
  @override
  Map<String, BreezSDK> build() {
    return <String, BreezSDK>{};
  }

  void add(String key, BreezSDK value) {
    state = {...state, key: value};
  }
}

// A FutureProvider that initializes BreezSDK for each existing account and populates the breezSdkMap.
@riverpod
void initializeBreezSdks(InitializeBreezSdksRef ref) {
  final accounts = ref.watch(accountsProvider);
  for (final account in accounts) {
    ref
        .read(
          breezeSdkLightningNodeServiceProvider(
            account.nodeId,
          ),
        )
        .existingNodeConnect(
          account.nodeId,
          account.workingDirPath,
          AppNetwork.bitcoin,
        );
  }
}
