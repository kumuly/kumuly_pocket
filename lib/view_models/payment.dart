import 'package:equatable/equatable.dart';
import 'package:kumuly_pocket/entities/payment_entity.dart';

class Payment extends Equatable {
  const Payment({required this.paymentHash});

  final String paymentHash;

  // from payment_entity
  factory Payment.fromPaymentEntity(PaymentEntity paymentEntity) {
    return Payment(
      paymentHash: paymentEntity.paymentHash,
    );
  }

  @override
  List<Object?> get props => [
        paymentHash,
      ];
}
