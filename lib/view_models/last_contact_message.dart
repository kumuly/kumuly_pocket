import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:kumuly_pocket/enums/payment_direction.dart';

@immutable
class LastContactMessage extends Equatable {
  final String contactName;
  final String? contactImagePath;
  final String? description;
  final int? timestamp;
  final int? amountSat;
  final PaymentDirection? direction;

  const LastContactMessage({
    required this.contactName,
    this.contactImagePath,
    this.description,
    this.timestamp,
    this.amountSat,
    this.direction,
  });

  String get dateTime {
    return timestamp != null
        ? DateFormat.yMd().add_jm().format(
              DateTime.fromMillisecondsSinceEpoch(
                timestamp! * 1000,
              ),
            )
        : '';
  }

  @override
  List<Object?> get props => [
        contactName,
        contactImagePath,
        description,
        timestamp,
        amountSat,
        direction,
      ];
}
