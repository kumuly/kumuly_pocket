import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/app_network.dart';
import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/enums/local_currency.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

@riverpod
BitcoinUnit bitcoinUnit(BitcoinUnitRef ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider).requireValue;

  final bitcoinUnitSetting =
      sharedPreferences.getString(kBitcoinUnitSettingsKey);

  if (bitcoinUnitSetting == null) {
    return BitcoinUnit.sat;
  }

  return BitcoinUnit.values
      .firstWhere((element) => element.name == bitcoinUnitSetting);
}

@riverpod
AppNetwork bitcoinNetwork(BitcoinNetworkRef ref) {
  return AppNetwork.bitcoin; // Todo: Get from settings
}

@riverpod
LocalCurrency localCurrency(LocalCurrencyRef ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider).requireValue;

  final localCurrencySetting =
      sharedPreferences.getString(kLocalCurrencySettingsKey);

  if (localCurrencySetting == null) {
    return LocalCurrency.euro;
  }

  return LocalCurrency.values
      .firstWhere((element) => element.name == localCurrencySetting);
}
