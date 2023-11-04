import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class ReceiveSatsState extends Equatable {
  const ReceiveSatsState({
    this.amountSat,
    this.description,
    this.invoice,
    this.onChainAddress,
    this.onChainMaxAmount,
    this.onChainMinAmount,
    this.swapFeeEstimate,
    this.isPaid = false,
    this.isSwapInProgress = false,
  });

  final int? amountSat;
  final String? description;
  final String? invoice;
  final String? onChainAddress;
  final int? onChainMaxAmount;
  final int? onChainMinAmount;
  final int? swapFeeEstimate;
  final bool isFetchingSwapInfo = false; // Todo: use these state bools
  final bool isSwapAvailable =
      false; // Todo: use the state bools to improve the screens
  final bool isPaid;
  final bool isSwapInProgress;

  ReceiveSatsState copyWith({
    int? amountSat,
    String? description,
    String? invoice,
    String? onChainAddress,
    int? onChainMaxAmount,
    int? onChainMinAmount,
    int? swapFeeEstimate,
  }) {
    return ReceiveSatsState(
      amountSat: amountSat ?? this.amountSat,
      description: description ?? this.description,
      invoice: invoice ?? this.invoice,
      onChainAddress: onChainAddress ?? this.onChainAddress,
      onChainMaxAmount: onChainMaxAmount ?? this.onChainMaxAmount,
      onChainMinAmount: onChainMinAmount ?? this.onChainMinAmount,
      swapFeeEstimate: swapFeeEstimate ?? this.swapFeeEstimate,
    );
  }

  int get amountInBTC => (amountSat! + (swapFeeEstimate ?? 0)) ~/ 100000000;

  String get bip21Uri {
    if (amountSat! > onChainMaxAmount! || amountSat! < onChainMinAmount!) {
      return '$invoice';
    }

    return 'bitcoin:$onChainAddress?amount=$amountInBTC&lightning=$invoice';
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
      ];
}
