import 'package:breez_sdk/breez_sdk.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'breez_sdk_providers.g.dart';

@Riverpod(keepAlive: true)
BreezSDK breezSdk(BreezSdkRef ref) {
  // Since the initialization of the Breez SDK is not async,
  //  it is overridden in the main.dart file to make it synchronous.
  //  And here we don't need to do anything but declare the provider.
  throw UnimplementedError();
}
