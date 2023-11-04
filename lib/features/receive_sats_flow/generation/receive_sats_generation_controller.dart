import 'package:kumuly_pocket/features/receive_sats_flow/generation/receive_sats_generation_state.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
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
      state = state.copyWith(
        amountSat: null,
        onChainAddress: null,
        onChainMaxAmount: null,
        onChainMinAmount: null,
        swapFeeEstimate: null,
      );
    } else {
      final amountSat = int.parse(amount);
      state = state.copyWith(amountSat: amountSat);
      print('amount sat: $amountSat');
    }
  }

  Future<void> fetchSwapInfo() async {
    final swapInInfo = await ref
        .read(breezeSdkLightningNodeServiceProvider)
        .getSwapInInfo(state.amountSat!);
    state = state.copyWith(
      onChainAddress: swapInInfo.bitcoinAddress,
      onChainMaxAmount: swapInInfo.maxAmount,
      onChainMinAmount: swapInInfo.minAmount,
      swapFeeEstimate: swapInInfo.feeEstimate,
    );

    print('bitcoin address: ${swapInInfo.bitcoinAddress}');
    print('max amount: ${swapInInfo.maxAmount}');
    print('min amount: ${swapInInfo.minAmount}');
    print('fee estimate: ${swapInInfo.feeEstimate}');
  }

  Future<void> createInvoice() async {
    final invoice =
        await ref.read(breezeSdkLightningNodeServiceProvider).createInvoice(
              state.amountSat!,
              state.description,
            );

    print(invoice);

    state = state.copyWith(invoice: invoice);
  }
}
