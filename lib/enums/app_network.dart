import 'package:breez_sdk/bridge_generated.dart';

/// Bitcoin network enum
enum AppNetwork {
  ///Classic Bitcoin
  bitcoin,

  ///Bitcoin’s testnet
  testnet,

  ///Bitcoin’s signet
  signet,

  ///Bitcoin’s regtest
  regtest,
}

extension AppNetworkExtension on AppNetwork {
  EnvironmentType get breezSdkEnvironmentType {
    switch (this) {
      case AppNetwork.bitcoin:
        return EnvironmentType.Production;
      case AppNetwork.testnet:
        return EnvironmentType.Staging;
      default:
        throw ArgumentError('Unsupported environment');
    }
  }
}
