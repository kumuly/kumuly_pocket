import 'package:flutter/material.dart';
import 'package:kumuly_pocket/enums/promo_type.dart';
import 'package:kumuly_pocket/features/promo_flow/details/promo_details_state.dart';
import 'package:kumuly_pocket/services/lightning_node/impl/breez_sdk_lightning_node_service.dart';
import 'package:kumuly_pocket/services/lightning_node/lightning_node_service.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'promo_details_controller.g.dart';

@riverpod
class PromoDetailsController extends _$PromoDetailsController {
  @override
  PromoDetailsState build(
    String id,
    Promo? promo,
  ) {
    if (promo != null) {
      return PromoDetailsState(
        promo: promo,
      );
    } else {
      // TODO: Fetch promo from API by id
      return PromoDetailsState(
        promo: Promo(
          id: '1',
          type: PromoType.custom,
          tag: 'Happy Hour',
          headline:
              'Savor limitless servings of Japanese tapas and sake between 5 PM and 7 PM.',
          description:
              'Dive into a tantalizing array of Japanese tapas, expertly crafted by our chefs to tantalize your taste buds. From crispy tempura and savory yakitori to delicate sushi rolls and flavorful gyoza, our menu boasts a variety of traditional and contemporary delights.\n\nComplement your culinary adventure with the smooth and refined taste of premium sake. Served fresh and expertly curated, our sake selection perfectly enhances the flavors of our tapas, providing you with an unforgettable dining experience.',
          images: [
            Image.asset(
              'assets/images/dummy_promo_carousel_1.png',
              fit: BoxFit.cover,
            ),
            Image.asset(
              'assets/images/dummy_promo_carousel_2.png',
              fit: BoxFit.cover,
            ),
            Image.asset(
              'assets/images/dummy_promo_carousel_3.png',
              fit: BoxFit.cover,
            ),
            Image.asset(
              'assets/images/dummy_promo_carousel_4.png',
              fit: BoxFit.cover,
            ),
            Image.asset(
              'assets/images/dummy_promo_carousel_5.png',
              fit: BoxFit.cover,
            ),
          ],
          originalPrice: 10,
          discountValue: 0,
          termsAndConditions: const [
            'This promotion is only valid for payments made with Bitcoin.',
            'Is exclusively available at Oishiki restaurant on Tuesdays, Wednesdays, and Thursdays from 5:00 PM to 7:00 PM.',
            'This promotion is for sake only; other drinks are not included.',
            'Takeout and delivery orders are not eligible for this promotion.',
            'Cannot be shared with other guests or taken away for later consumption.',
            'Guests must be of legal drinking age to consume sake.',
          ],
          merchant: PromoMerchant(
            id: "1",
            logo: Image.asset(
              'assets/images/dummy_logo.png',
              fit: BoxFit.cover,
            ),
            name: 'Oishiki Japanese Food',
            verified: true,
            rating: 4.5,
            address: '1234 Main Street, New York, NY 10001',
            distance: 'Nearby - 2km',
          ),
          lnurlPayLink:
              'LNURL1DP68GURN8GHJ7WPHXUUKGDRPX3JNSTNY9EMX7MR5V9NK2CTSWQHXJME0D3H82UNVWQH5UMNCXEF95UC9QG3',
          expiry: 1702853999,
        ),
      );
    }
  }

  Future<void> fetchAmountToPayInSat() async {
    final (minAmountSat, _) = await ref
        .read(breezeSdkLightningNodeServiceProvider)
        .getLnurlPayAmounts(
          promo!.lnurlPayLink,
        );
    state = state.copyWith(
      amountSat: minAmountSat,
    );
  }

  Future<void> payForPromo() async {
    try {
      // Pay the promo
      // Since promos have a fixed price in fiat, the amount in sats changes all the time.
      //  Therefore we add 3% to the amount to make sure we have enough,
      //  but also will not pay it when it became 3% more expensive from the confirmed amount.
      //  By setting useMinimumAmount to true, we make sure that we will always pay the minimum.
      //  So it can never exceed 3% of the confirmed amount in sats and could be even less than the confirmed amount.
      await ref.read(breezeSdkLightningNodeServiceProvider).payLnUrlPay(
            promo!.lnurlPayLink,
            state.amountSat! + (state.amountSat! * 0.03).toInt(),
            useMinimumAmount: true,
          );
    } catch (e) {
      // Update the price in sats to pay again since this changes constantly
      fetchAmountToPayInSat();
      if (e is LnUrlPayMinAmount || e is LnUrlPayMaxAmount) {
        state = state.copyWith(
          priceUpdatedError: true,
          paymentErrorMessage: '',
        );
      } else {
        state = state.copyWith(
          priceUpdatedError: false,
          paymentErrorMessage: e.toString(),
        );
      }
      rethrow;
    }
  }

  // ToDo: Implement the following methods
  Future<void> storePromoPaymentIntent() async {
    // Store the promo id and timestamp into activity
  }

  Future<void> waitForPromoPayment() async {
    // Wait for the payment to be fulfilled
    // if successful, store the payment hash and secret together with the promo id
    // if failed, remove the payment intent from the activity
  }
}
