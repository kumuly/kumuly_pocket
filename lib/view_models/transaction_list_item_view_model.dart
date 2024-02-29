import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
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

  TransactionListItemViewModel.fromTransactionEntity(
    TransactionEntity entity,
  )   : id = entity.id,
        type = entity.type,
        direction = entity.receivedAmountSat > entity.sentAmountSat
            ? TransactionDirection.incoming
            : TransactionDirection.outgoing,
        amountSat = (entity.receivedAmountSat - entity.sentAmountSat).abs(),
        timestamp = entity.timestamp;

  bool get isIncoming => TransactionDirection.incoming == direction;
  bool get isOutgoing => TransactionDirection.outgoing == direction;

  String? formatLocaleDate(String locale) {
    if (timestamp == null) {
      return null;
    }

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
    // Format as per the locale language to something like: 30 de junio de 2021
    return DateFormat.yMMMMd(locale).format(date);
  }

  String? formatLocaleTime(String locale) {
    if (timestamp == null) {
      return null;
    }

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
    return DateFormat.Hm(locale).format(date);
  }

  int? get day {
    if (timestamp == null) {
      return null;
    }

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
    return date.day;
  }

  int? get month {
    if (timestamp == null) {
      return null;
    }

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
    return date.month;
  }

  int? get year {
    if (timestamp == null) {
      return null;
    }

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
    return date.year;
  }

  bool get isToday {
    if (timestamp == null) {
      return false;
    }

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
    final now = DateTime.now();
    return date.day == now.day &&
        date.month == now.month &&
        date.year == now.year;
  }

  bool get isYesterday {
    if (timestamp == null) {
      return false;
    }

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
    final now = DateTime.now();
    return date.day == now.subtract(const Duration(days: 1)).day &&
        date.month == now.subtract(const Duration(days: 1)).month &&
        date.year == now.subtract(const Duration(days: 1)).year;
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
