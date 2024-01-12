import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/view_models/invoice.dart';

@immutable
class ReceiveSatsState extends Equatable {
  const ReceiveSatsState({
    required this.amountController,
    this.amountSat,
    // this.label, Todo: add label with default value being the name of the user
    this.description,
    required this.descriptionController,
    required this.hoursTillExpiry,
    required this.hoursTillExpiryController,
    this.feeEstimate,
    this.onChainMaxAmount,
    this.onChainMinAmount,
    this.assumeFee = false,
    this.invoice,
    this.onChainAddress,
    this.isFetchingEditedInvoice = false,
  });

  final TextEditingController amountController;
  final int? amountSat;
  final int hoursTillExpiry;
  final TextEditingController hoursTillExpiryController;
  final String? description;
  final TextEditingController descriptionController;
  final int? feeEstimate;
  final int? onChainMaxAmount;
  final int? onChainMinAmount;
  final bool assumeFee;
  final Invoice? invoice;
  final String? onChainAddress;
  final bool isFetchingEditedInvoice;

  ReceiveSatsState copyWith({
    TextEditingController? amountController,
    int? amountSat,
    String? description,
    TextEditingController? descriptionController,
    int? hoursTillExpiry,
    TextEditingController? hoursTillExpiryController,
    int? feeEstimate,
    int? onChainMaxAmount,
    int? onChainMinAmount,
    bool? assumeFee,
    Invoice? invoice,
    String? onChainAddress,
    bool? isFetchingEditedInvoice,
  }) {
    return ReceiveSatsState(
      amountController: amountController ?? this.amountController,
      amountSat: amountSat ?? this.amountSat,
      description: description ?? this.description,
      descriptionController:
          descriptionController ?? this.descriptionController,
      hoursTillExpiry: hoursTillExpiry ?? this.hoursTillExpiry,
      hoursTillExpiryController:
          hoursTillExpiryController ?? this.hoursTillExpiryController,
      feeEstimate: feeEstimate ?? this.feeEstimate,
      onChainMaxAmount: onChainMaxAmount ?? this.onChainMaxAmount,
      onChainMinAmount: onChainMinAmount ?? this.onChainMinAmount,
      assumeFee: assumeFee ?? this.assumeFee,
      invoice: invoice ?? this.invoice,
      onChainAddress: onChainAddress ?? this.onChainAddress,
      isFetchingEditedInvoice:
          isFetchingEditedInvoice ?? this.isFetchingEditedInvoice,
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

    if (!isSwapInPossible) {
      return invoice!.bolt11;
    }

    return 'bitcoin:$onChainAddress?'
        'amount=${amountToPaySat! / 100000000.toDouble()}&'
        '${description != null && description!.isNotEmpty ? 'message=$description&' : ''}'
        'lightning=${invoice!.bolt11}';
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

  int get expiry {
    return hoursTillExpiry * 60 * 60;
  }

  String get formattedExpiryPreview {
    final DateTime date;
    if (hoursTillExpiryController.text == '') {
      date = DateTime.now()
          .add(const Duration(hours: kDefaultHoursTillInvoiceExpiry));
    } else {
      date = DateTime.now()
          .add(Duration(hours: int.parse(hoursTillExpiryController.text)));
    }

    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  String get formattedExpiry {
    final DateTime date = DateTime.now().add(Duration(hours: hoursTillExpiry));

    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  String get invoiceInfoToShare {
    return '${isSwapInPossible ? '${bip21Uri!}\n\n' : ''}'
        'Lightning Invoice: ${invoice!.bolt11}\n'
        '${isSwapInPossible ? 'Bitcoin address: $onChainAddress\n' : ''}'
        'Amount: $amountToPaySat sats or ${amountToPaySat! / 100000000.toDouble()} BTC\n'
        '${description != null && description!.isNotEmpty ? 'Description: ${descriptionController.text}\n' : ''}'
        'Expiry: $formattedExpiry';
  }

  @override
  List<Object?> get props => [
        amountController,
        amountSat,
        description,
        descriptionController,
        hoursTillExpiry,
        hoursTillExpiryController,
        feeEstimate,
        onChainMaxAmount,
        onChainMinAmount,
        assumeFee,
        invoice,
        onChainAddress,
        isFetchingEditedInvoice,
      ];
}
