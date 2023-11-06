import 'package:kumuly_pocket/features/pocket/pocket_payments_history_state.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/view_models/payment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pocket_payments_history_controller.g.dart';

@riverpod
class PocketPaymentsHistoryController
    extends _$PocketPaymentsHistoryController {
  @override
  FutureOr<PocketPaymentsHistoryState> build(int paymentsLimit) async {
    final payments =
        await ref.read(breezeSdkLightningNodeServiceProvider).getPaymentHistory(
              limit: paymentsLimit,
            );

    return PocketPaymentsHistoryState(
      paymentsLimit: paymentsLimit,
      payments:
          payments.map((entity) => Payment.fromPaymentEntity(entity)).toList(),
      paymentsOffset: payments.length,
      hasMorePayments: payments.length == paymentsLimit,
    );
  }

  Future<void> fetchPayments({bool refresh = false}) async {
    await update((state) async {
      // Fetch payments
      final paymentEntities = await ref
          .read(breezeSdkLightningNodeServiceProvider)
          .getPaymentHistory(
            offset: refresh ? null : state.paymentsOffset,
            limit: state.paymentsLimit,
          );

      // Update state
      return state.copyWith(
        payments: refresh
            ? paymentEntities
                .map((entity) => Payment.fromPaymentEntity(entity))
                .toList()
            : [
                ...state.payments,
                ...paymentEntities
                    .map((entity) => Payment.fromPaymentEntity(entity))
                    .toList(),
              ],
        paymentsOffset: state.paymentsOffset + paymentEntities.length,
        hasMorePayments: paymentEntities.length == state.paymentsLimit,
      );
    });
  }
}
