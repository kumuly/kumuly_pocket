import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/enums/local_currency.dart';
import 'package:kumuly_pocket/providers/breez_sdk_providers.dart';
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
      ? ref
          .watch(satToBtcProvider(amountSat))
          ?.toStringAsFixed(8)
          .replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "")
      : amountSat.toDouble().toStringAsFixed(0);
}

@riverpod
Future<double?> fiatRates(FiatRatesRef ref, LocalCurrency localCurrency) async {
  final fiatRates = await ref.watch(breezSdkProvider).fetchFiatRates();

  return fiatRates[localCurrency.code]?.value;
}

@riverpod
Future<double?> satToLocal(SatToLocalRef ref, int? amountSat) async {
  final localCurrency = ref.watch(localCurrencyProvider);
  final amountBtc = ref.read(satToBtcProvider(amountSat));

  if (amountBtc == null) {
    return null;
  }

  return ref.watch(fiatRatesProvider(localCurrency)).when(
      data: (bitcoinPrice) => amountBtc * bitcoinPrice!,
      error: (error, stack) => null,
      loading: () => null);
}

@riverpod
Future<int?> localToSat(LocalToSatRef ref, double? amountLocal) async {
  final localCurrency = ref.watch(localCurrencyProvider);

  if (amountLocal == null) {
    return null;
  }

  return ref.watch(fiatRatesProvider(localCurrency)).when(
      data: (bitcoinPrice) =>
          ref.watch(btcToSatProvider(amountLocal / bitcoinPrice!)),
      error: (error, stack) => null,
      loading: () => null);
}
