import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/entities/bip21_entity.dart';
import 'package:kumuly_pocket/entities/invoice_entity.dart';
import 'package:kumuly_pocket/entities/lnurl_pay_entity.dart';
import 'package:kumuly_pocket/enums/payment_request_type.dart';

@immutable
class PaymentRequestEntity extends Equatable {
  const PaymentRequestEntity({
    required this.type,
    this.invoice,
    this.bitcoinAddress,
    this.bip21,
    this.lnurlPay,
    this.nodeId,
  });

  final PaymentRequestType type;
  final InvoiceEntity? invoice;
  final String? bitcoinAddress;
  final Bip21Entity? bip21;
  final LnurlPayEntity? lnurlPay;
  final String? nodeId;

  @override
  List<Object?> get props => [
        type,
        invoice,
        bitcoinAddress,
        bip21,
        lnurlPay,
        nodeId,
      ];
}
