import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/entities/lnurl_pay_entity.dart';

@immutable
class LnurlPay extends Equatable {
  final String lnurl;
  final int? minSendableSat;
  final int? maxSendableSat;
  final String? metadata;

  const LnurlPay({
    required this.lnurl,
    this.minSendableSat,
    this.maxSendableSat,
    this.metadata,
  });

  factory LnurlPay.fromLnurlPayEntity(LnurlPayEntity entity) {
    return LnurlPay(
      lnurl: entity.lnurl,
      minSendableSat: entity.minSendableSat,
      maxSendableSat: entity.maxSendableSat,
      metadata: entity.metadata,
    );
  }

  String get partialLnurl {
    return '${lnurl.substring(0, 8)}...${lnurl.substring(lnurl.length - 8)}';
  }

  @override
  List<Object?> get props => [
        lnurl,
        minSendableSat,
        maxSendableSat,
        metadata,
      ];
}
