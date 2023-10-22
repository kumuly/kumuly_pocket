import 'package:breez_sdk/bridge_generated.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class InvoiceEntity extends Equatable {
  final String bolt11;
  final String payeePubkey;
  final String paymentHash;
  final String? description;
  final String? descriptionHash;
  final int? amountMsat;
  final int timestamp;
  final int expiry;
  final List<RouteHint> routingHints;
  final Uint8List paymentSecret;
  final OpeningFeeParams? openingFeeParams;
  final int? openingFeeMsat;

  const InvoiceEntity({
    required this.bolt11,
    required this.payeePubkey,
    required this.paymentHash,
    this.description,
    this.descriptionHash,
    this.amountMsat,
    required this.timestamp,
    required this.expiry,
    required this.routingHints,
    required this.paymentSecret,
    this.openingFeeParams,
    this.openingFeeMsat,
  });

  @override
  List<Object?> get props => [
        bolt11,
        payeePubkey,
        paymentHash,
        description,
        descriptionHash,
        amountMsat,
        timestamp,
        expiry,
        routingHints,
        paymentSecret,
        openingFeeParams,
        openingFeeMsat,
      ];
}
