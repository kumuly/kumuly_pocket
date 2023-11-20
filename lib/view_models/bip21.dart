import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/entities/bip21_entity.dart';

@immutable
class Bip21 extends Equatable {
  final String bitcoin;
  final int? amountSat;
  final String? label;
  final String? message;
  final String? lightning;

  const Bip21({
    required this.bitcoin,
    this.amountSat,
    this.label,
    this.message,
    this.lightning,
  });

  factory Bip21.fromBip21Entity(Bip21Entity entity) {
    return Bip21(
      bitcoin: entity.bitcoin,
      amountSat: entity.amountSat,
      label: entity.label,
      message: entity.message,
      lightning: entity.lightning,
    );
  }

  String get partialBitcoinAddress {
    return '${bitcoin.substring(0, 8)}...${bitcoin.substring(bitcoin.length - 8)}';
  }

  @override
  List<Object?> get props => [
        bitcoin,
        amountSat,
        label,
        message,
        lightning,
      ];
}
