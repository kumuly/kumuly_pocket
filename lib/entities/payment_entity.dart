import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/enums/lightning_channel_state.dart';
import 'package:kumuly_pocket/enums/payment_direction.dart';
import 'package:kumuly_pocket/enums/payment_status.dart';

@immutable
class PaymentEntity extends Equatable {
  final String id;
  final PaymentDirection direction;
  final int paymentTime;
  final int amountMsat;
  final int feeMsat;
  final PaymentStatus status;
  final String? description;
  final LightningPaymentDetailsEntity? lightningPaymentDetails;
  final ClosedChannelPaymentDetailsEntity? closedChannelPaymentDetails;

  const PaymentEntity({
    required this.id,
    required this.direction,
    required this.paymentTime,
    required this.amountMsat,
    required this.feeMsat,
    required this.status,
    this.description,
    this.lightningPaymentDetails,
    this.closedChannelPaymentDetails,
  });

  @override
  List<Object?> get props => [
        id,
        direction,
        paymentTime,
        amountMsat,
        feeMsat,
        status,
        description,
        lightningPaymentDetails,
        closedChannelPaymentDetails,
      ];
}

@immutable
class LightningPaymentDetailsEntity extends Equatable {
  const LightningPaymentDetailsEntity({
    required this.paymentHash,
    required this.label,
    required this.destinationPubkey,
    required this.paymentPreimage,
    required this.keysend,
    required this.bolt11,
    this.lnurlSuccessAction,
    this.lnAddress,
    this.lnurlMetadata,
    this.lnurlWithdrawEndpoint,
  });

  final String paymentHash;
  final String label;
  final String destinationPubkey;
  final String paymentPreimage;
  final bool keysend;
  final String bolt11;

  /// Only set for [PaymentType::Sent] payments that are part of a LNURL-pay workflow where
  /// the endpoint returns a success action
  final LnurlSuccessAction? lnurlSuccessAction;

  /// Only set for [PaymentType::Sent] payments that are sent to a Lightning Address
  final String? lnAddress;

  /// Only set for [PaymentType::Sent] payments where the receiver endpoint returned LNURL metadata
  final String? lnurlMetadata;

  /// Only set for [PaymentType::Received] payments that were received as part of LNURL-withdraw
  final String? lnurlWithdrawEndpoint;

  @override
  List<Object?> get props => [
        paymentHash,
        label,
        destinationPubkey,
        paymentPreimage,
        keysend,
        bolt11,
        lnurlSuccessAction,
        lnAddress,
        lnurlMetadata,
        lnurlWithdrawEndpoint,
      ];
}

@immutable
class ClosedChannelPaymentDetailsEntity extends Equatable {
  const ClosedChannelPaymentDetailsEntity({
    required this.shortChannelId,
    required this.state,
    required this.fundingTxid,
    this.closingTxid,
  });

  final String shortChannelId;
  final LightningChannelState state;
  final String fundingTxid;

  /// Can be empty for older closed channels.
  final String? closingTxid;

  @override
  List<Object?> get props => [
        shortChannelId,
        state,
        fundingTxid,
        closingTxid,
      ];
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
