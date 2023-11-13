import 'package:breez_sdk/bridge_generated.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/entities/invoice_entity.dart';

@immutable
class Invoice extends Equatable {
  final String bolt11;
  final String payeePubkey;
  final String paymentHash;
  final String? description;
  final int? amountSat;
  final int timestamp;
  final int expiry;
  final Uint8List paymentSecret;
  final OpeningFeeParams? openingFeeParams;
  final int? openingFeeMsat;

  const Invoice({
    required this.bolt11,
    required this.payeePubkey,
    required this.paymentHash,
    this.description,
    this.amountSat,
    required this.timestamp,
    required this.expiry,
    required this.paymentSecret,
    this.openingFeeParams,
    this.openingFeeMsat,
  });

  factory Invoice.fromInvoiceEntity(InvoiceEntity entity) {
    return Invoice(
      bolt11: entity.bolt11,
      payeePubkey: entity.payeePubkey,
      paymentHash: entity.paymentHash,
      description: entity.description,
      amountSat: entity.amountMsat! ~/ 1000,
      timestamp: entity.timestamp,
      expiry: entity.expiry,
      paymentSecret: entity.paymentSecret,
      openingFeeParams: entity.openingFeeParams,
      openingFeeMsat: entity.openingFeeMsat,
    );
  }

  @override
  List<Object?> get props => [
        bolt11,
        payeePubkey,
        paymentHash,
        description,
        timestamp,
        expiry,
        paymentSecret,
        openingFeeParams,
        openingFeeMsat,
      ];
}
