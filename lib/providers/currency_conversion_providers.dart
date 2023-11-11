import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'currency_conversion_providers.g.dart';

@riverpod
double? satToBtc(SatToBtcRef ref, int? amountSat) {
  if (amountSat == null) {
    return null;
  }
  return amountSat / 100000000.toDouble();
}

@riverpod
int? btcToSat(BtcToSatRef ref, double? amountBtc) {
  if (amountBtc == null) {
    return null;
  }
  return (amountBtc * 100000000).toInt();
}

@riverpod
String? displayBitcoinAmount(DisplayBitcoinAmountRef ref, int? amountSat) {
  final bitcoinUnit = ref.watch(bitcoinUnitProvider);

  if (amountSat == null) {
    return null;
  }

  return bitcoinUnit == BitcoinUnit.btc
      ? ref.watch(satToBtcProvider(amountSat))?.toStringAsFixed(8)
      : amountSat.toDouble().toStringAsFixed(0);
}

@riverpod
double? satToLocal(SatToLocalRef ref, int? amountSat) {
  final localCurrency = ref.watch(localCurrencyProvider);
  final amountBtc = ref.read(satToBtcProvider(amountSat));

  if (amountBtc == null) {
    return null;
  }
  // Todo: Implement currency conversion based on localCurrency
  return amountBtc * 37000;
}

@riverpod
int? localToSat(LocalToSatRef ref, double? amountLocal) {
  final localCurrency = ref.watch(localCurrencyProvider);

  if (amountLocal == null) {
    return null;
  }

  // Todo: Implement currency conversion based on localCurrency
  return ref.read(btcToSatProvider(amountLocal / 37000));
}
