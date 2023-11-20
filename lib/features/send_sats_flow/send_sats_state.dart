import 'package:breez_sdk/bridge_generated.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/enums/on_chain_fee_velocity.dart';
import 'package:kumuly_pocket/enums/payment_request_type.dart';
import 'package:kumuly_pocket/view_models/bip21.dart';
import 'package:kumuly_pocket/view_models/invoice.dart';
import 'package:kumuly_pocket/view_models/lnurl_pay.dart';

@immutable
class SendSatsState extends Equatable {
  const SendSatsState({
    required this.destinationFocusNode,
    required this.destinationTextController,
    required this.amountFocusNode,
    required this.amountTextController,
    this.paymentRequestType,
    this.invoice,
    this.bitcoinAddress,
    this.bip21,
    this.nodeId,
    this.lnurlPay,
    this.isValidDestination = false,
    this.amountSat,
    this.recommendedOnChainFees,
    this.selectedOnChainFeeVelocity = OnChainFeeVelocity.medium,
    this.destinationInputError,
    this.amountInputError,
  });

  final FocusNode destinationFocusNode;
  final TextEditingController destinationTextController;
  final FocusNode amountFocusNode;
  final TextEditingController amountTextController;
  final PaymentRequestType? paymentRequestType;
  final Invoice? invoice;
  final String? bitcoinAddress;
  final Bip21? bip21;
  final String? nodeId;
  final LnurlPay? lnurlPay;
  final bool isValidDestination;
  final int? amountSat;
  final Map<OnChainFeeVelocity, int>? recommendedOnChainFees;
  final OnChainFeeVelocity? selectedOnChainFeeVelocity;
  final Error? destinationInputError;
  final Error? amountInputError;

  String get partialBitcoinAddress {
    if (bitcoinAddress == null) {
      return '';
    } else {
      return '${bitcoinAddress!.substring(0, 8)}...${bitcoinAddress!.substring(bitcoinAddress!.length - 8)}';
    }
  }

  String get partialNodeId {
    if (nodeId == null) {
      return '';
    } else {
      return '${nodeId!.substring(0, 8)}...${nodeId!.substring(nodeId!.length - 8)}';
    }
  }

  SendSatsState copyWith({
    FocusNode? destinationFocusNode,
    TextEditingController? destinationTextController,
    FocusNode? amountFocusNode,
    TextEditingController? amountTextController,
    PaymentRequestType? paymentRequestType,
    Invoice? invoice,
    String? bitcoinAddress,
    Bip21? bip21,
    LnurlPay? lnurlPay,
    String? nodeId,
    bool? isValidDestination,
    int? amountSat,
    Map<OnChainFeeVelocity, int>? recommendedOnChainFees,
    OnChainFeeVelocity? selectedOnChainFeeVelocity,
    Error? destinationInputError,
    Error? amountInputError,
    // int? onChainMaxAmount,
    // int? onChainMinAmount,
    // int? onChainFeeEstimate,
    // SwapOutInfo? swapOutInfo,
  }) {
    return SendSatsState(
      destinationFocusNode: destinationFocusNode ?? this.destinationFocusNode,
      destinationTextController:
          destinationTextController ?? this.destinationTextController,
      amountFocusNode: amountFocusNode ?? this.amountFocusNode,
      amountTextController: amountTextController ?? this.amountTextController,
      paymentRequestType: paymentRequestType ?? this.paymentRequestType,
      invoice: invoice ?? this.invoice,
      bitcoinAddress: bitcoinAddress ?? this.bitcoinAddress,
      bip21: bip21 ?? this.bip21,
      nodeId: nodeId ?? this.nodeId,
      lnurlPay: lnurlPay ?? this.lnurlPay,
      isValidDestination: isValidDestination ?? this.isValidDestination,
      amountSat: amountSat ?? this.amountSat,
      recommendedOnChainFees:
          recommendedOnChainFees ?? this.recommendedOnChainFees,
      selectedOnChainFeeVelocity:
          selectedOnChainFeeVelocity ?? this.selectedOnChainFeeVelocity,
      destinationInputError:
          destinationInputError ?? this.destinationInputError,
      amountInputError: amountInputError ?? this.amountInputError,
      // onChainMaxAmount: onChainMaxAmount ?? this.onChainMaxAmount,
      // onChainMinAmount: onChainMinAmount ?? this.onChainMinAmount,
      // onChainFeeEstimate: onChainFeeEstimate ?? this.onChainFeeEstimate,
      // swapOutInfo: swapOutInfo ?? this.swapOutInfo,
    );
  }

  @override
  List<Object?> get props => [
        destinationFocusNode,
        destinationTextController,
        amountFocusNode,
        amountTextController,
        paymentRequestType,
        invoice,
        bitcoinAddress,
        bip21,
        nodeId,
        lnurlPay,
        isValidDestination,
        amountSat,
        recommendedOnChainFees,
        selectedOnChainFeeVelocity,
        destinationInputError,
        amountInputError,
        // onChainMaxAmount,
        // onChainMinAmount,
        // onChainFeeEstimate,
        // swapInInfo,
      ];
}
