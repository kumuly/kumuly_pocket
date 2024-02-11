import 'package:kumuly_pocket/features/pocket/payment_details/pocket_payment_details_state.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/view_models/payment_details_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pocket_payment_details_controller.g.dart';

@riverpod
class PocketPaymentsDetailsController
    extends _$PocketPaymentsDetailsController {
  @override
  FutureOr<PocketPaymentDetailsState> build(String hash) async {
    final payment = await ref
        .read(breezeSdkLightningNodeServiceProvider)
        .getPaymentByHash(hash);

    if (payment == null) {
      throw const PaymentNotFoundException();
    }

    return PocketPaymentDetailsState(
        paymentDetails: PaymentDetailsViewModel.fromPaymentEntity(payment));
  }
}

class PaymentNotFoundException implements Exception {
  const PaymentNotFoundException();
}
