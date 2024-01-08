import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/view_models/invoice.dart';

@immutable
class ReceiveSatsState extends Equatable {
  const ReceiveSatsState({
    this.amountSat,
    this.description,
    this.isFetchingFeeInfo = false,
    this.lightningFeeEstimate,
    this.onChainFeeEstimate,
    this.onChainMaxAmount,
    this.onChainMinAmount,
    this.isSwapAvailable = true,
    this.assumeFees = false,
    this.invoice,
    this.onChainAddress,
  });

  final int? amountSat;
  final String? description;
  final bool isFetchingFeeInfo;
  final int? lightningFeeEstimate;
  final int? onChainFeeEstimate;
  final int? onChainMaxAmount;
  final int? onChainMinAmount;
  final bool isSwapAvailable;
  final bool assumeFees;
  final Invoice? invoice;
  final String? onChainAddress;

  ReceiveSatsState copyWith({
    int? amountSat,
    String? description,
    bool? isFetchingFeeInfo,
    int? lightningFeeEstimate,
    int? onChainFeeEstimate,
    int? onChainMaxAmount,
    int? onChainMinAmount,
    bool? isSwapAvailable,
    bool? assumeFees,
    Invoice? invoice,
    String? onChainAddress,
  }) {
    return ReceiveSatsState(
      amountSat: amountSat ?? this.amountSat,
      description: description ?? this.description,
      isFetchingFeeInfo: isFetchingFeeInfo ?? this.isFetchingFeeInfo,
      lightningFeeEstimate: lightningFeeEstimate ?? this.lightningFeeEstimate,
      onChainFeeEstimate: onChainFeeEstimate ?? this.onChainFeeEstimate,
      onChainMaxAmount: onChainMaxAmount ?? this.onChainMaxAmount,
      onChainMinAmount: onChainMinAmount ?? this.onChainMinAmount,
      isSwapAvailable: isSwapAvailable ?? this.isSwapAvailable,
      assumeFees: assumeFees ?? this.assumeFees,
      invoice: invoice ?? this.invoice,
      onChainAddress: onChainAddress ?? this.onChainAddress,
    );
  }

  int? get amountToReceiveSat => 0;

  int? get invoiceAmountSat => 0;

  int? get onChainAmountSat => 0;

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

    return 'bitcoin:$onChainAddress?amount=$onChainAmountSat&lightning=${invoice!.bolt11}';
  }

  @override
  List<Object?> get props => [
        amountSat,
        description,
        isFetchingFeeInfo,
        lightningFeeEstimate,
        onChainFeeEstimate,
        onChainMaxAmount,
        onChainMinAmount,
        isSwapAvailable,
        assumeFees,
        invoice,
        onChainAddress,
      ];
}
