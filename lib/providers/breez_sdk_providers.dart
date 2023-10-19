import 'package:breez_sdk/breez_bridge.dart';
import 'package:kumuly_pocket/services/account_service.dart';
import 'package:kumuly_pocket/services/authentication_service.dart';
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

@riverpod
BreezSDK newBreezSdk(NewBreezSdkRef ref) {
  print('newBreezSdk rebuild');
  final breezSdk = BreezSDK();
  return breezSdk;
}

// A FutureProvider that initializes BreezSDK for each existing account and populates the breezSdkMap.
@riverpod
void initializeBreezSdks(InitializeBreezSdksRef ref) {
  final accounts = ref.watch(accountsProvider);
  for (final account in accounts) {
    BreezSDK breezSdk = BreezSDK();
    breezSdk.initialize();
    ref.read(breezSdkMapProvider.notifier).add(account.nodeId, breezSdk);
  }
}

@riverpod
BreezSDK connectedBreezSdk(ConnectedBreezSdkRef ref) {
  print('connectedBreezSdk rebuild');

  final connectedAccount = ref.watch(connectedAccountProvider);
  final breezSdkMap = ref.watch(breezSdkMapProvider);
  final newBreezSdk = ref.watch(newBreezSdkProvider);

  return connectedAccount.when(
    data: (value) {
      // if the nodeId exists in the map, return it, else return the default instance
      print('connectedBreezSdk value is empty: ${value.isEmpty}');
      if (value.isEmpty) return newBreezSdk;
      print('connectedBreezSdk nodeId: ${value.nodeId}');
      if (!breezSdkMap.containsKey(value.nodeId)) return newBreezSdk;
      print('connectedBreezSdk nodeId is in map');
      return breezSdkMap[value.nodeId]!;
    },
    loading: () => newBreezSdk,
    error: (err, stack) => newBreezSdk,
  );
}
