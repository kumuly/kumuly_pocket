import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String paymentHash;

  const PaymentEntity({required this.paymentHash});

  @override
  List<Object?> get props => [
        paymentHash,
      ];
}
