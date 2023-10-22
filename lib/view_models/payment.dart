import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  const Payment();

  // from payment_entity
  factory Payment.fromPaymentEntity() {
    return const Payment();
  }

  @override
  List<Object?> get props => [];
}
