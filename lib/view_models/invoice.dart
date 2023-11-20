import 'package:breez_sdk/bridge_generated.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/entities/invoice_entity.dart';

@immutable
class Invoice extends Equatable {
  const Invoice({
    required this.bolt11,
    required this.payeePubkey,
    required this.paymentHash,
    this.description,
    this.amountSat,
    required this.timestamp,
    required this.expiry,
    this.paymentSecret,
    this.openingFeeParams,
    this.openingFeeMsat,
  });

  final String bolt11;
  final String payeePubkey;
  final String paymentHash;
  final String? description;
  final int? amountSat;
  final int timestamp;
  final int expiry;
  final Uint8List? paymentSecret;
  final OpeningFeeParams? openingFeeParams;
  final int? openingFeeMsat;

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

  String get partialBolt11 {
    if (bolt11.isEmpty) {
      return '';
    } else {
      return '${bolt11.substring(0, 8)}...${bolt11.substring(bolt11.length - 8)}';
    }
  }

  int get secondsTillExpiry {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final timeDifference = timestamp + expiry - now;
    return timeDifference < 0 ? 0 : timeDifference;
  }

  String displayTimeTillExpiry(
    String seconds,
    String minutes,
    String hours,
    String days,
    String months,
  ) {
    final differenceInSeconds = secondsTillExpiry < 0 ? 0 : secondsTillExpiry;
    final differenceInMinutes = differenceInSeconds ~/ 60;
    final differenceInHours = differenceInMinutes ~/ 60;
    final differenceInDays = differenceInHours ~/ 24;
    final differenceInMonths = differenceInDays ~/ 30;

    if (differenceInMonths > 0) {
      return '$differenceInMonths $months';
    } else if (differenceInDays > 0) {
      return '$differenceInDays $days';
    } else if (differenceInHours > 0) {
      return '$differenceInHours $hours';
    } else if (differenceInMinutes > 0) {
      return '$differenceInMinutes $minutes';
    } else {
      return '$differenceInSeconds $seconds';
    }
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
