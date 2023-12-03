import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/view_models/invoice.dart';

@immutable
class ReceiveSatsGenerationState extends Equatable {
  const ReceiveSatsGenerationState({
    this.amountSat,
    this.description,
    this.invoice,
    this.onChainAddress,
    this.onChainMaxAmount,
    this.onChainMinAmount,
    this.swapFeeEstimate,
    this.isSwapAvailable = true,
  });

  final int? amountSat;
  final String? description;
  final Invoice? invoice;
  final String? onChainAddress;
  final int? onChainMaxAmount;
  final int? onChainMinAmount;
  final int? swapFeeEstimate;
  final bool
      isSwapAvailable; // Todo: use the state bools to improve the screens

  ReceiveSatsGenerationState copyWith({
    int? amountSat,
    String? description,
    Invoice? invoice,
    String? onChainAddress,
    int? onChainMaxAmount,
    int? onChainMinAmount,
    int? swapFeeEstimate,
    bool? isSwapAvailable,
  }) {
    return ReceiveSatsGenerationState(
      amountSat: amountSat ?? this.amountSat,
      description: description ?? this.description,
      invoice: invoice ?? this.invoice,
      onChainAddress: onChainAddress ?? this.onChainAddress,
      onChainMaxAmount: onChainMaxAmount ?? this.onChainMaxAmount,
      onChainMinAmount: onChainMinAmount ?? this.onChainMinAmount,
      swapFeeEstimate: swapFeeEstimate ?? this.swapFeeEstimate,
      isSwapAvailable: isSwapAvailable ?? this.isSwapAvailable,
    );
  }

  double get amountToSendOnChain =>
      (amountSat! + (swapFeeEstimate ?? 0)) / 100000000;

  String? get partialOnChainAddress => onChainAddress == null ||
          onChainAddress!.isEmpty
      ? null
      : '${onChainAddress!.substring(0, 8)}...${onChainAddress!.substring(onChainAddress!.length - 8)}';

  String? get partialInvoice => invoice == null || invoice!.bolt11.isEmpty
      ? null
      : '${invoice!.bolt11.substring(0, 8)}...${invoice!.bolt11.substring(invoice!.bolt11.length - 8)}';

  String? get bip21Uri {
    if (amountSat == null) {
      return null;
    }

    if (onChainAddress == null ||
        onChainAddress!.isEmpty ||
        amountSat! > onChainMaxAmount! ||
        amountSat! < onChainMinAmount!) {
      return invoice!.bolt11;
    }

    return 'bitcoin:$onChainAddress?amount=$amountToSendOnChain&lightning=${invoice!.bolt11}';
  }

  @override
  List<Object?> get props => [
        amountSat,
        description,
        invoice,
        onChainAddress,
        onChainMaxAmount,
        onChainMinAmount,
        swapFeeEstimate,
        isSwapAvailable,
      ];
}
