import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'promo_payment_controller.g.dart';

@riverpod
class PromoPaymentController extends _$PromoPaymentController {
  @override
  void build(
    LightningNodeService lightningNodeService,
  ) {}

  Future<void> pay(String paymentLink) async {
    /*final paymentRequest = await lightningNodeService.decodePaymentRequest(
      paymentLink,
    );

    print(paymentRequest);

    final payment = await lightningNodeService.pay(
      paymentRequest.paymentRequest,
    );

    print(payment);*/
  }
}
