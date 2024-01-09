import 'package:flutter/material.dart';
import 'package:kumuly_pocket/entities/swap_in_info_entity.dart';
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
    final amountTextController = TextEditingController();
    return ReceiveSatsState(amountController: amountTextController);
  }

  void amountChangeHandler(String? amount) {
    if (amount == null || amount.isEmpty) {
      state = ReceiveSatsState(amountController: state.amountController);
    } else {
      final amountSat = ref.watch(bitcoinUnitProvider) == BitcoinUnit.sat
          ? int.parse(amount)
          : ref.watch(btcToSatProvider(double.parse(amount)));

      state = state.copyWith(amountSat: amountSat);
      print('amount sat: $amountSat');
    }
  }

  Future<void> fetchFeeInfo() async {
    final nodeServiceNotifier = ref.read(breezeSdkLightningNodeServiceProvider);
    state = state.copyWith(isFetchingFeeInfo: true);

    // Obtain the swap in info from the node service
    try {
      final swapInInfo =
          await nodeServiceNotifier.getSwapInInfo(state.amountSat!);

      state = state.copyWith(
        onChainFeeEstimate: swapInInfo.feeEstimate,
        onChainAddress: swapInInfo.bitcoinAddress,
        onChainMaxAmount: swapInInfo.maxAmount,
        onChainMinAmount: swapInInfo.minAmount,
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

    // Obtain the channel opening fee estimate from the node service
    final channelOpeningFeeEstimate = await nodeServiceNotifier
        .getChannelOpeningFeeEstimate(state.amountSat!);

    state = state.copyWith(
      lightningFeeEstimate: channelOpeningFeeEstimate,
      isFetchingFeeInfo: false,
    );

    print('channel opening fee estimate: $channelOpeningFeeEstimate');
  }

  void passFeesToPayerChangeHandler(bool value) {
    state = state.copyWith(assumeFees: !value);
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
      rethrow;
    }
  }
}
