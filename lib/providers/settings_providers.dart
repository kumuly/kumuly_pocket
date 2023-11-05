import 'package:kumuly_pocket/enums/app_network.dart';
import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/enums/local_currency.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

@riverpod
BitcoinUnit bitcoinUnit(BitcoinUnitRef ref) {
  return BitcoinUnit.sat; // Todo: Get from settings
}

@riverpod
AppNetwork bitcoinNetwork(BitcoinNetworkRef ref) {
  return AppNetwork.bitcoin; // Todo: Get from settings
}

@riverpod
LocalCurrency localCurrency(LocalCurrencyRef ref) {
  return LocalCurrency.euro; // Todo: Get from settings
}
