import 'package:flutter/material.dart';
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
      try {
        final amountSat = ref.watch(bitcoinUnitProvider) == BitcoinUnit.sat
            ? int.parse(amount)
            : ref.watch(btcToSatProvider(double.parse(amount)));

        state = state.copyWith(amountSat: amountSat);
      } catch (e) {
        state = ReceiveSatsState(amountController: state.amountController);
      }
    }
  }

  Future<void> fetchFee() async {
    // Reset the fee estimate by creating a new state with only the amount controller and amount sat
    state = ReceiveSatsState(
      amountController: state.amountController,
      amountSat: state.amountSat,
    );

    final nodeServiceNotifier = ref.read(breezeSdkLightningNodeServiceProvider);

    // Obtain the channel opening fee estimate from the node service
    final channelOpeningFeeEstimate = await nodeServiceNotifier
        .getChannelOpeningFeeEstimate(state.amountSat!);

    state = state.copyWith(
      feeEstimate: channelOpeningFeeEstimate,
    );

    print('channel opening fee estimate: $channelOpeningFeeEstimate');
  }

  void passFeesToPayerChangeHandler(bool value) {
    state = state.copyWith(assumeFee: !value);
  }

  Future<void> createOnChainAddress() async {
    try {
      final nodeServiceNotifier =
          ref.read(breezeSdkLightningNodeServiceProvider);
      final swapInInfo =
          await nodeServiceNotifier.getSwapInInfo(state.amountToPaySat!);

      state = state.copyWith(
        onChainAddress: swapInInfo.bitcoinAddress,
        onChainMaxAmount: swapInInfo.maxAmount,
        onChainMinAmount: swapInInfo.minAmount,
      );

      print('bitcoin address: ${swapInInfo.bitcoinAddress}');
      print('max amount: ${swapInInfo.maxAmount}');
      print('min amount: ${swapInInfo.minAmount}');
    } catch (e) {
      print(e);
    }
  }

  Future<void> createInvoice() async {
    try {
      final invoice =
          await ref.read(breezeSdkLightningNodeServiceProvider).createInvoice(
                state.amountToPaySat!,
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
