import 'package:flutter/material.dart';
import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/enums/payment_request_type.dart';
import 'package:kumuly_pocket/features/send_sats_flow/send_sats_state.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/repositories/lightning_node_repository.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/view_models/bip21.dart';
import 'package:kumuly_pocket/view_models/invoice.dart';
import 'package:kumuly_pocket/view_models/lnurl_pay.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_sats_controller.g.dart';

@riverpod
class SendSatsController extends _$SendSatsController {
  @override
  SendSatsState build() {
    final destinationFocus = FocusNode();
    final destinationTextController = TextEditingController();
    final amountTextController = TextEditingController();
    final amountFocus = FocusNode();

    destinationFocus.addListener(() {
      if (!destinationFocus.hasFocus) {
        onDestinationUnfocusHandler();
      }
    });

    ref.onDispose(() {
      destinationFocus.dispose();
      destinationTextController.dispose();
      amountTextController.dispose();
      amountFocus.dispose();
    });

    return SendSatsState(
      destinationFocusNode: destinationFocus,
      destinationTextController: destinationTextController,
      amountTextController: amountTextController,
      amountFocusNode: amountFocus,
    );
  }

  Future<void> onDestinationChangeHandler(String destination) async {
    state = SendSatsState(
      destinationFocusNode: state.destinationFocusNode,
      destinationTextController: state.destinationTextController,
      amountTextController: state.amountTextController,
      amountFocusNode: state.amountFocusNode,
    );

    if (destination.isEmpty) {
      return;
    }

    try {
      final parsedPaymentRequest = await ref
          .read(breezeSdkLightningNodeRepositoryProvider)
          .decodePaymentRequest(destination);

      final invoice = parsedPaymentRequest.invoice != null
          ? Invoice.fromInvoiceEntity(parsedPaymentRequest.invoice!)
          : null;
      final bip21 = parsedPaymentRequest.bip21 != null
          ? Bip21.fromBip21Entity(parsedPaymentRequest.bip21!)
          : null;
      final lnurlPay = parsedPaymentRequest.lnurlPay != null
          ? LnurlPay.fromLnurlPayEntity(parsedPaymentRequest.lnurlPay!)
          : null;

      final amountSat = invoice != null
          ? invoice.amountSat
          : bip21 != null
              ? bip21.amountSat
              : lnurlPay?.minSendableSat;

      state = state.copyWith(
        paymentRequestType: parsedPaymentRequest.type,
        invoice: invoice,
        bitcoinAddress: parsedPaymentRequest.bitcoinAddress,
        bip21: bip21,
        nodeId: parsedPaymentRequest.nodeId,
        lnurlPay: lnurlPay,
        isValidDestination: true,
        amountSat: amountSat,
      );

      state.amountTextController.text =
          state.amountSat == null ? '' : state.amountSat.toString();
      state.destinationFocusNode.unfocus();
    } catch (e) {
      print('Error parsing payment request: $e');
    }
  }

  Future<void> onDestinationUnfocusHandler() async {
    if (!state.isValidDestination) {
      print('Invalid destination');
      state = state.copyWith(
        destinationInputError: Error(),
      );
    }
  }

  Future<void> amountChangeHandler(String amount) async {
    if (amount.isEmpty) {
      // Keep everything except for the amount and amount input error
      state = SendSatsState(
        amountSat: null,
        amountInputError: null,
        destinationFocusNode: state.destinationFocusNode,
        destinationTextController: state.destinationTextController,
        amountFocusNode: state.amountFocusNode,
        amountTextController: state.amountTextController,
        paymentRequestType: state.paymentRequestType,
        invoice: state.invoice,
        bitcoinAddress: state.bitcoinAddress,
        bip21: state.bip21,
        nodeId: state.nodeId,
        lnurlPay: state.lnurlPay,
        isValidDestination: state.isValidDestination,
        recommendedOnChainFees: state.recommendedOnChainFees,
        selectedOnChainFeeVelocity: state.selectedOnChainFeeVelocity,
        destinationInputError: state.destinationInputError,
      );
    } else {
      // Todo: Validate amount, check balance, check min and maxsendable etc. and set error if needed
      final unit = ref.watch(bitcoinUnitProvider);
      final amountSat = unit == BitcoinUnit.sat
          ? int.parse(amount)
          : ref.watch(btcToSatProvider(double.parse(amount)));
      state = SendSatsState(
        amountSat: amountSat,
        amountInputError: null,
        destinationFocusNode: state.destinationFocusNode,
        destinationTextController: state.destinationTextController,
        amountFocusNode: state.amountFocusNode,
        amountTextController: state.amountTextController,
        paymentRequestType: state.paymentRequestType,
        invoice: state.invoice,
        bitcoinAddress: state.bitcoinAddress,
        bip21: state.bip21,
        nodeId: state.nodeId,
        lnurlPay: state.lnurlPay,
        isValidDestination: state.isValidDestination,
        recommendedOnChainFees: state.recommendedOnChainFees,
        selectedOnChainFeeVelocity: state.selectedOnChainFeeVelocity,
        destinationInputError: state.destinationInputError,
      );
    }
  }

  Future<void> fetchFees() async {
    final lightningNodeServiceProvider =
        ref.read(breezeSdkLightningNodeServiceProvider);
    if ([PaymentRequestType.bitcoinAddress, PaymentRequestType.bip21]
        .contains(state.paymentRequestType)) {
      // Todo: also fetch and set swapOutInfo with swap fees and min/max
      final onchainFees = await lightningNodeServiceProvider.recommendedFees;
      state = state.copyWith(recommendedOnChainFees: onchainFees);
    }
  }

  Future<void> sendPayment() async {
    final lightningNodeServiceProvider =
        ref.read(breezeSdkLightningNodeServiceProvider);
    switch (state.paymentRequestType) {
      case PaymentRequestType.bitcoinAddress:
        return lightningNodeServiceProvider.swapOut(
            state.bitcoinAddress!,
            state.amountSat!,
            state.recommendedOnChainFees![state.selectedOnChainFeeVelocity!]!);
      case PaymentRequestType.bip21:
        return lightningNodeServiceProvider.swapOut(
            state.bip21!.bitcoin,
            state.amountSat!,
            state.recommendedOnChainFees![state.selectedOnChainFeeVelocity!]!);
      case PaymentRequestType.bolt11:
        return lightningNodeServiceProvider.payInvoice(
          bolt11: state.invoice!.bolt11,
          amountSat: state.invoice!.amountSat != null ? null : state.amountSat,
        );
      case PaymentRequestType.lnurlPay:
        return lightningNodeServiceProvider.payLnUrlPay(
          state.lnurlPay!.lnurl,
          state.amountSat!,
        );
      case PaymentRequestType.nodeId:
        return lightningNodeServiceProvider.keysend(
          state.nodeId!,
          state.amountSat!,
        );
      case _:
        return;
    }
  }
}
