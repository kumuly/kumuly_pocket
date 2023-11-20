import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Bip21Entity extends Equatable {
  final String bitcoin;
  final int? amountSat;
  final String? label;
  final String? message;
  final String? lightning;

  const Bip21Entity({
    required this.bitcoin,
    this.amountSat,
    this.label,
    this.message,
    this.lightning,
  });

  factory Bip21Entity.fromUri(String uri) {
    final params = uri.split('?')[1].split('&');
    return Bip21Entity(
      bitcoin: uri.split('bitcoin:')[1].split('?')[0],
      amountSat: (double.parse(params
                  .firstWhere(
                    (element) => element.startsWith('amount='),
                    orElse: () => '',
                  )
                  .split('amount=')[1]) *
              100000000)
          .toInt(),
      label: params
          .firstWhere(
            (element) => element.startsWith('label='),
            orElse: () => '',
          )
          .split('label=')[1],
      message: params
          .firstWhere(
            (element) => element.startsWith('message='),
            orElse: () => '',
          )
          .split('message=')[1],
      lightning: params
          .firstWhere(
            (element) => element.startsWith('lightning='),
            orElse: () => '',
          )
          .split('lightning=')[1],
    );
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
