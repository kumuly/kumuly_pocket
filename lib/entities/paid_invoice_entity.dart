import 'package:equatable/equatable.dart';

class PaidInvoiceEntity extends Equatable {
  const PaidInvoiceEntity({
    required this.bolt11,
    required this.paymentHash,
    required this.amountSat,
  });

  final String bolt11;
  final String paymentHash;
  final int amountSat;

  @override
  List<Object?> get props => [
        bolt11,
        paymentHash,
        amountSat,
      ];
}
