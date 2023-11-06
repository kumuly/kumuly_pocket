import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:kumuly_pocket/entities/payment_entity.dart';
import 'package:kumuly_pocket/enums/payment_direction.dart';
import 'package:kumuly_pocket/enums/payment_status.dart';

class Payment extends Equatable {
  const Payment({
    required this.id,
    required this.amountSat,
    required this.feeSat,
    this.paymentHash,
    required this.direction,
    required this.status,
    required this.timestamp,
    this.description,
  });

  final String id;
  final int amountSat;
  final int feeSat;
  final String? paymentHash;
  final PaymentDirection direction;
  final PaymentStatus status;
  final int timestamp;
  final String? description;

  // from payment_entity
  factory Payment.fromPaymentEntity(
    PaymentEntity paymentEntity,
  ) {
    if (paymentEntity.lightningPaymentDetails != null) {
      return Payment(
        id: paymentEntity.id,
        amountSat: paymentEntity.amountMsat ~/ 1000,
        feeSat: paymentEntity.feeMsat ~/ 1000,
        paymentHash: paymentEntity.lightningPaymentDetails!.paymentHash,
        direction: paymentEntity.direction,
        status: paymentEntity.status,
        timestamp: paymentEntity.paymentTime,
        description: paymentEntity.description,
      );
    }

    return Payment(
      id: paymentEntity.id,
      amountSat: paymentEntity.amountMsat ~/ 1000,
      feeSat: paymentEntity.feeMsat ~/ 1000,
      direction: paymentEntity.direction,
      status: paymentEntity.status,
      timestamp: paymentEntity.paymentTime,
      description: paymentEntity.description,
    );
  }

  String get dateTime => DateFormat.yMd().add_jm().format(
        DateTime.fromMillisecondsSinceEpoch(
          timestamp * 1000,
        ),
      );

  @override
  List<Object?> get props => [
        id,
        amountSat,
        feeSat,
        paymentHash,
        direction,
        status,
        timestamp,
        description,
      ];
}
