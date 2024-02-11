import 'package:breez_sdk/breez_sdk.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'breez_sdk_providers.g.dart';

@Riverpod(keepAlive: true)
BreezSDK breezSdk(BreezSdkRef ref) {
  return BreezSDK();
}
