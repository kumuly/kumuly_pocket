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
String? displayBitcoinAmount(DisplayBitcoinAmountRef ref, int? amountSat) {
  final bitcoinUnit = ref.watch(bitcoinUnitProvider);

  if (amountSat == null) {
    return null;
  }

  return bitcoinUnit == BitcoinUnit.btc
      ? ref.watch(satToBtcProvider(amountSat))?.toStringAsFixed(8)
      : amountSat.toDouble().toStringAsFixed(0);
}
