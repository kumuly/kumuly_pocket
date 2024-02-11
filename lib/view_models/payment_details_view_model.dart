import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/entities/payment_entity.dart';
import 'package:kumuly_pocket/enums/transaction_direction.dart';
import 'package:kumuly_pocket/enums/transaction_status.dart';
import 'package:intl/intl.dart';

@immutable
class PaymentDetailsViewModel extends Equatable {
  const PaymentDetailsViewModel({
    required this.amountSat,
    required this.direction,
    this.timestamp,
    required this.status,
    required this.feeAmountSat,
  });

  final int amountSat;
  final TransactionDirection direction;
  final int? timestamp;
  final TransactionStatus status;
  final int feeAmountSat;

  PaymentDetailsViewModel.fromPaymentEntity(PaymentEntity entity)
      : amountSat = (entity.receivedAmountSat - entity.sentAmountSat).abs(),
        direction = entity.receivedAmountSat > entity.sentAmountSat
            ? TransactionDirection.incoming
            : TransactionDirection.outgoing,
        timestamp = entity.timestamp,
        status = entity.status,
        feeAmountSat = entity.feeAmountSat;

  bool get isIncoming => direction == TransactionDirection.incoming;
  bool get isOutgoing => direction == TransactionDirection.outgoing;

  String? get formattedTimestamp {
    if (timestamp == null) {
      return null;
    }

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
    return DateFormat("dd MMMM y '・' h:mm a").format(date);
  }

  @override
  List<Object?> get props => [
        amountSat,
        direction,
        timestamp,
        status,
        feeAmountSat,
      ];
}
