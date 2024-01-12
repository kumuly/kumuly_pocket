import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/view_models/invoice.dart';

@immutable
class ReceiveSatsState extends Equatable {
  const ReceiveSatsState({
    required this.amountController,
    this.amountSat,
    this.description,
    this.expiry,
    this.feeEstimate,
    this.onChainMaxAmount,
    this.onChainMinAmount,
    this.assumeFee = false,
    this.invoice,
    this.onChainAddress,
  });

  final TextEditingController amountController;
  final int? amountSat;
  final int? expiry;
  final String? description;
  final int? feeEstimate;
  final int? onChainMaxAmount;
  final int? onChainMinAmount;
  final bool assumeFee;
  final Invoice? invoice;
  final String? onChainAddress;

  ReceiveSatsState copyWith({
    TextEditingController? amountController,
    int? amountSat,
    String? description,
    int? expiry,
    int? feeEstimate,
    int? onChainMaxAmount,
    int? onChainMinAmount,
    bool? assumeFee,
    Invoice? invoice,
    String? onChainAddress,
  }) {
    return ReceiveSatsState(
      amountController: amountController ?? this.amountController,
      amountSat: amountSat ?? this.amountSat,
      description: description ?? this.description,
      expiry: expiry ?? this.expiry,
      feeEstimate: feeEstimate ?? this.feeEstimate,
      onChainMaxAmount: onChainMaxAmount ?? this.onChainMaxAmount,
      onChainMinAmount: onChainMinAmount ?? this.onChainMinAmount,
      assumeFee: assumeFee ?? this.assumeFee,
      invoice: invoice ?? this.invoice,
      onChainAddress: onChainAddress ?? this.onChainAddress,
    );
  }

  int? get amountToReceiveSat {
    if (amountSat == null || feeEstimate == null) {
      return null;
    }

    if (assumeFee) {
      return amountSat! - feeEstimate!;
    } else {
      return amountSat;
    }
  }

  int? get amountToPaySat {
    if (amountSat == null || feeEstimate == null) {
      return null;
    }

    if (assumeFee) {
      return amountSat;
    } else {
      return amountSat! + feeEstimate!;
    }
  }

  String? get partialOnChainAddress => onChainAddress == null ||
          onChainAddress!.isEmpty
      ? null
      : '${onChainAddress!.substring(0, 8)}...${onChainAddress!.substring(onChainAddress!.length - 8)}';

  String? get partialInvoice => invoice == null || invoice!.bolt11.isEmpty
      ? null
      : '${invoice!.bolt11.substring(0, 8)}...${invoice!.bolt11.substring(invoice!.bolt11.length - 8)}';

  String? get bip21Uri {
    if (invoice == null || invoice!.bolt11.isEmpty) {
      return null;
    }

    if (onChainAddress == null || onChainAddress!.isEmpty) {
      return invoice!.bolt11;
    }

    return 'bitcoin:$onChainAddress?amount=$amountToPaySat&lightning=${invoice!.bolt11}';
  }

  bool get isSwapInPossible {
    if (onChainAddress == null || onChainAddress!.isEmpty) {
      return false;
    }
    if (amountToPaySat! > onChainMaxAmount!) {
      return false;
    }
    if (amountToPaySat! < onChainMinAmount!) {
      return false;
    }
    return true;
  }

  bool get isAmountTooSmallForSwapIn {
    if (onChainAddress == null || onChainAddress!.isEmpty) {
      return false;
    }
    if (amountToPaySat! < onChainMinAmount!) {
      return true;
    }
    return false;
  }

  bool get isAmountTooBigForSwapIn {
    if (onChainAddress == null || onChainAddress!.isEmpty) {
      return false;
    }
    if (amountToPaySat! > onChainMaxAmount!) {
      return true;
    }
    return false;
  }

  @override
  List<Object?> get props => [
        amountController,
        amountSat,
        description,
        expiry,
        feeEstimate,
        onChainMaxAmount,
        onChainMinAmount,
        assumeFee,
        invoice,
        onChainAddress,
      ];
}
