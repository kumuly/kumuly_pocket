import 'package:breez_sdk/breez_sdk.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'breez_sdk_providers.g.dart';

@riverpod
BreezSDK breezSdk(BreezSdkRef ref) {
  final breezSdk = BreezSDK();
  // Initialize flutter specific listeners and logs.
  //breezSdk.initialize(); // Todo: Check if already initialized, this can only be called once, before connecting.
  return breezSdk;
}
