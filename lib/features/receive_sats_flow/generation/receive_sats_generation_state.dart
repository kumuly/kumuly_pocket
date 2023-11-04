import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

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
    this.isFetchingSwapInfo = false,
    this.isSwapAvailable = false,
  });

  final int? amountSat;
  final String? description;
  final String? invoice;
  final String? onChainAddress;
  final int? onChainMaxAmount;
  final int? onChainMinAmount;
  final int? swapFeeEstimate;
  final bool isFetchingSwapInfo; // Todo: use these state bools
  final bool
      isSwapAvailable; // Todo: use the state bools to improve the screens

  ReceiveSatsGenerationState copyWith({
    int? amountSat,
    String? description,
    String? invoice,
    String? onChainAddress,
    int? onChainMaxAmount,
    int? onChainMinAmount,
    int? swapFeeEstimate,
    bool? isFetchingSwapInfo,
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
      isFetchingSwapInfo: isFetchingSwapInfo ?? this.isFetchingSwapInfo,
      isSwapAvailable: isSwapAvailable ?? this.isSwapAvailable,
    );
  }

  int get amountBtc => amountSat! ~/ 100000000;

  int get amountToSendOnChain =>
      (amountSat! + (swapFeeEstimate ?? 0)) ~/ 100000000;

  String? get bip21Uri {
    if (amountSat == null) {
      return null;
    }

    if (onChainAddress == null ||
        onChainAddress!.isEmpty ||
        amountSat! > onChainMaxAmount! ||
        amountSat! < onChainMinAmount!) {
      return '$invoice';
    }

    return 'bitcoin:$onChainAddress?amount=$amountToSendOnChain&lightning=$invoice';
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
        isFetchingSwapInfo,
        isSwapAvailable,
      ];
}
