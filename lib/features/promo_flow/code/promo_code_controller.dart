import 'package:kumuly_pocket/features/promo_flow/code/promo_code_state.dart';
import 'package:kumuly_pocket/features/promo_flow/details/promo_details_controller.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'promo_code_controller.g.dart';

@riverpod
class PromoCodeController extends _$PromoCodeController {
  @override
  PromoCodeState build(
    String id,
    Promo? promo,
  ) {
    // Todo: Get promo and paymentHash from activity or from the promo_details_state/passed through the constructor
    ref.watch(promoDetailsControllerProvider(id, promo));
    const paymentHash =
        '100f51c0d368d2d8d8f3627964930a07e28b0b4466e55864198f07ecabaaeaf6';
    // Todo: Check if promo is redeemed already (from the activity and/or the server)
    const isRedeemed = false;
    // Todo: Check if promo is expired (from the activity and/or the server)
    const isExpired = false;

    return const PromoCodeState(
      paymentHash: paymentHash,
      isRedeemed: isRedeemed,
      isExpired: isExpired,
    );
  }
}
