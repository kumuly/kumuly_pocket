// Todo: Add following providers:
//  - Bitcoin network provider -> bitcoin, testnet, regtest, signet

import 'package:kumuly_pocket/enums/app_network.dart';
import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bitcoin_providers.g.dart';

@riverpod
AppNetwork bitcoinNetwork(BitcoinNetworkRef ref) {
  return AppNetwork.bitcoin; // Todo: Get from settings
}

@riverpod
BitcoinUnit bitcoinUnit(BitcoinUnitRef ref) {
  return BitcoinUnit.sat; // Todo: Get from settings
}

@riverpod
double? satToBtc(SatToBtcRef ref, int? amountSat) {
  if (amountSat == null) {
    return null;
  }
  return amountSat / 100000000.toDouble();
}

@riverpod
double? displayBitcoinAmount(DisplayBitcoinAmountRef ref, int? amountSat) {
  final bitcoinUnit = ref.watch(bitcoinUnitProvider);

  if (amountSat == null) {
    return null;
  }

  return bitcoinUnit == BitcoinUnit.btc
      ? ref.watch(satToBtcProvider(amountSat))
      : amountSat.toDouble();
}
