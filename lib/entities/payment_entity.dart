import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/entities/transaction_entity.dart';

@immutable
class PaymentEntity extends TransactionEntity {
  final int feeAmountSat;
  final String? description;
  final String destinationPubkey;
  final String paymentPreimage;
  final bool keysend;
  final String bolt11;

  /// Only set for sent payments that are part of a LNURL-pay workflow where
  /// the endpoint returns a success action
  final LnurlSuccessAction? lnurlSuccessAction;

  /// Only set for sent payments that are sent to a Lightning Address
  final String? lnAddress;

  /// Only set for sent payments where the receiver endpoint returned LNURL metadata
  final String? lnurlMetadata;

  /// Only set for received payments that were received as part of LNURL-withdraw
  final String? lnurlWithdrawEndpoint;

  const PaymentEntity({
    required super.id,
    super.receivedAmountSat = 0,
    super.sentAmountSat = 0,
    required super.timestamp,
    required super.status,
    required super.type,
    required this.feeAmountSat,
    this.description,
    required this.destinationPubkey,
    required this.paymentPreimage,
    required this.keysend,
    required this.bolt11,
    this.lnurlSuccessAction,
    this.lnAddress,
    this.lnurlMetadata,
    this.lnurlWithdrawEndpoint,
  });

  @override
  List<Object?> get props => super.props
    ..addAll(
      [
        feeAmountSat,
        description,
        destinationPubkey,
        paymentPreimage,
        keysend,
        bolt11,
        lnurlSuccessAction,
        lnAddress,
        lnurlMetadata,
        lnurlWithdrawEndpoint,
      ],
    );
}

@immutable
class LnurlSuccessAction extends Equatable {
  const LnurlSuccessAction({
    this.description,
    this.plaintext,
    this.message,
    this.url,
  });

  /// Aes
  /// Contents description, up to 144 characters
  final String? description;

  /// Decrypted content
  final String? plaintext;

  /// Message
  final String? message;

  /// Url
  final String? url;

  @override
  List<Object?> get props => [
        description,
        plaintext,
        message,
        url,
      ];
}
