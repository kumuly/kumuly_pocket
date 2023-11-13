import 'package:kumuly_pocket/features/promo_validation_flow/redemption/promo_validation_redemption_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'promo_validation_redemption_controller.g.dart';

@riverpod
class PromoValidationRedemptionController
    extends _$PromoValidationRedemptionController {
  @override
  PromoValidationRedemptionState build() {
    return const PromoValidationRedemptionState();
  }

  Future<void> validate() async {
    // Todo: post to server that this payment hash is consumed
    // Todo: receive the amount that was paid in Sats
    const amountSat = 90000;
    print('Setting to validated');
    state = state.copyWith(
        isValidated: true, isCancelled: false, amountSat: amountSat);
  }

  Future<void> cancel() async {
    // Todo: post to server that this payment hash is canceled and generate the withdraw LNURL
    // Todo: receive the amount that was paid in Sats
    const amountSat = 90000;
    print('Setting to validated');
    state = state.copyWith(
        isValidated: false, isCancelled: true, amountSat: amountSat);
  }
}
