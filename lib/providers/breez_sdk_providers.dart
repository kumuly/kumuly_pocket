import 'package:breez_sdk/breez_sdk.dart';
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
BreezSDK newBreezSdk(NewBreezSdkRef ref, String nodeId) {
  final breezSdk = BreezSDK();
  return breezSdk;
}

// A FutureProvider that initializes BreezSDK for each existing account and populates the breezSdkMap.
@riverpod
void initializeBreezSdks(InitializeBreezSdksRef ref) {
  final accounts = []; // Todo: change for ref.watch(accountsProvider);
  for (final account in accounts) {
    BreezSDK breezSdk = ref.read(newBreezSdkProvider(account.nodeId));
    breezSdk.initialize();
    ref.read(breezSdkMapProvider.notifier).add(account.nodeId, breezSdk);
  }
}

@riverpod
BreezSDK connectedBreezSdk(ConnectedBreezSdkRef ref) {
  final breezSdkMap = ref.watch(breezSdkMapProvider);
  // Todo: final connectedAccount = ref.watch(connectedAccountProvider);

  // we return only the BreezSdk of the connectedAccount
  return breezSdkMap['connectedAccountNodeId']!;
}
