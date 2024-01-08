import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/receive_sats_state.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/view_models/invoice.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'receive_sats_controller.g.dart';

@riverpod
class ReceiveSatsController extends _$ReceiveSatsController {
  @override
  ReceiveSatsState build() {
    return const ReceiveSatsState();
  }

  void amountChangeHandler(String? amount) {
    if (amount == null || amount.isEmpty) {
      state = const ReceiveSatsState();
    } else {
      final amountSat = ref.watch(bitcoinUnitProvider) == BitcoinUnit.sat
          ? int.parse(amount)
          : ref.watch(btcToSatProvider(double.parse(amount)));

      state = state.copyWith(amountSat: amountSat);
      print('amount sat: $amountSat');
    }
  }

  Future<void> fetchFeeInfo() async {
    try {
      state = state.copyWith(isFetchingFeeInfo: true);

      final swapInInfo = await ref
          .read(breezeSdkLightningNodeServiceProvider)
          .getSwapInInfo(state.amountSat!);

      state = state.copyWith(
        isFetchingFeeInfo: false,
        onChainAddress: swapInInfo.bitcoinAddress,
        onChainMaxAmount: swapInInfo.maxAmount,
        onChainMinAmount: swapInInfo.minAmount,
        onChainFeeEstimate: swapInInfo.feeEstimate,
        isSwapAvailable: true,
      );

      print('bitcoin address: ${swapInInfo.bitcoinAddress}');
      print('max amount: ${swapInInfo.maxAmount}');
      print('min amount: ${swapInInfo.minAmount}');
      print('fee estimate: ${swapInInfo.feeEstimate}');
    } catch (e) {
      print(e);
      state = state.copyWith(
        isFetchingFeeInfo: false,
        isSwapAvailable: false,
      );
    }
  }

  void assumeFeeChangeHandler(bool value) {
    state = state.copyWith(assumeFees: value);
  }

  Future<void> createInvoice() async {
    try {
      final invoice =
          await ref.read(breezeSdkLightningNodeServiceProvider).createInvoice(
                state.amountSat!,
                state.description,
              );

      state = state.copyWith(invoice: Invoice.fromInvoiceEntity(invoice));
    } catch (e) {
      print(e);
      // Todo: set error in state
      throw const InvoiceCreationException('Failed to create invoice');
    }
  }
}

class InvoiceCreationException implements Exception {
  const InvoiceCreationException(this.message);

  final String message;
}
