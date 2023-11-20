import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class LnurlPayEntity extends Equatable {
  final String lnurl;
  final int? minSendableSat;
  final int? maxSendableSat;
  final String? metadata;

  const LnurlPayEntity({
    required this.lnurl,
    this.minSendableSat,
    this.maxSendableSat,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        lnurl,
        minSendableSat,
        maxSendableSat,
        metadata,
      ];
}
