import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/generation/receive_sats_generation_state.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/view_models/invoice.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'receive_sats_generation_controller.g.dart';

@riverpod
class ReceiveSatsGenerationController
    extends _$ReceiveSatsGenerationController {
  @override
  ReceiveSatsGenerationState build() {
    return const ReceiveSatsGenerationState();
  }

  void amountChangeHandler(String? amount) {
    if (amount == null || amount.isEmpty) {
      state = const ReceiveSatsGenerationState();
    } else {
      final amountSat = ref.watch(bitcoinUnitProvider) == BitcoinUnit.sat
          ? int.parse(amount)
          : ref.watch(btcToSatProvider(double.parse(amount)));

      state = state.copyWith(amountSat: amountSat);
      print('amount sat: $amountSat');
    }
  }

  Future<void> fetchSwapInfo() async {
    try {
      final swapInInfo = await ref
          .read(breezeSdkLightningNodeServiceProvider)
          .getSwapInInfo(state.amountSat!);
      state = state.copyWith(
        onChainAddress: swapInInfo.bitcoinAddress,
        onChainMaxAmount: swapInInfo.maxAmount,
        onChainMinAmount: swapInInfo.minAmount,
        swapFeeEstimate: swapInInfo.feeEstimate,
        isSwapAvailable: true,
      );

      print('bitcoin address: ${swapInInfo.bitcoinAddress}');
      print('max amount: ${swapInInfo.maxAmount}');
      print('min amount: ${swapInInfo.minAmount}');
      print('fee estimate: ${swapInInfo.feeEstimate}');
    } catch (e) {
      print(e);
      state = state.copyWith(
        isSwapAvailable: false,
      );
    }
  }

  Future<void> createInvoice() async {
    final invoice =
        await ref.read(breezeSdkLightningNodeServiceProvider).createInvoice(
              state.amountSat!,
              state.description,
            );

    print(invoice);

    state = state.copyWith(invoice: Invoice.fromInvoiceEntity(invoice));
  }
}
