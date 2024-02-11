import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/entities/transaction_entity.dart';
import 'package:kumuly_pocket/enums/transaction_direction.dart';
import 'package:kumuly_pocket/enums/transaction_type.dart';

@immutable
class TransactionListItemViewModel extends Equatable {
  final String id;
  final TransactionType type;
  final TransactionDirection direction;
  final int amountSat;
  final int? timestamp;

  const TransactionListItemViewModel({
    required this.id,
    required this.type,
    required this.direction,
    required this.amountSat,
    this.timestamp,
  });

  TransactionListItemViewModel.fromTransactionEntity(TransactionEntity entity)
      : id = entity.id,
        type = entity.type,
        direction = entity.receivedAmountSat > entity.sentAmountSat
            ? TransactionDirection.incoming
            : TransactionDirection.outgoing,
        amountSat = (entity.receivedAmountSat - entity.sentAmountSat).abs(),
        timestamp = entity.timestamp;

  bool get isIncoming => TransactionDirection.incoming == direction;
  bool get isOutgoing => TransactionDirection.outgoing == direction;

  String? get formattedTimestamp {
    if (timestamp == null) {
      return null;
    }

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  @override
  List<Object?> get props => [
        id,
        type,
        direction,
        amountSat,
        timestamp,
      ];
}
