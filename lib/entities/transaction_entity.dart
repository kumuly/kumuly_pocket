import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/enums/transaction_status.dart';
import 'package:kumuly_pocket/enums/transaction_type.dart';

@immutable
abstract class TransactionEntity extends Equatable {
  final String id;
  final int receivedAmountSat;
  final int sentAmountSat;
  final int? timestamp;
  final TransactionStatus status;
  final TransactionType type;

  const TransactionEntity({
    required this.id,
    this.receivedAmountSat = 0,
    this.sentAmountSat = 0,
    required this.timestamp,
    required this.status,
    required this.type,
  });

  @override
  List<Object?> get props => [
        id,
        receivedAmountSat,
        sentAmountSat,
        timestamp,
        status,
        type,
      ];
}
