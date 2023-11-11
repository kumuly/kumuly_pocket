import 'package:breez_sdk/breez_sdk.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'breez_sdk_providers.g.dart';

final _sdk = BreezSDK();

@riverpod
BreezSDK breezSdk(BreezSdkRef ref) {
  return _sdk;
}

@riverpod
Future<void> breezSdkInitialize(BreezSdkInitializeRef ref) async {
  final breezSdk = ref.watch(breezSdkProvider);
  // Initialize flutter specific listeners and logs.
  if (!(await breezSdk.isInitialized())) {
    print('BreezSDK is not initialized. Initializing now...');
    breezSdk.initialize();
  }
}
