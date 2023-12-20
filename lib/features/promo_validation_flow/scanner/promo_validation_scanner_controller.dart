import 'package:flutter/material.dart';
import 'package:kumuly_pocket/enums/promo_type.dart';
import 'package:kumuly_pocket/features/promo_validation_flow/scanner/promo_validation_scanner_state.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'promo_validation_scanner_controller.g.dart';

@riverpod
class PromoValidationScannerController
    extends _$PromoValidationScannerController {
  @override
  PromoValidationScannerState build() {
    return const PromoValidationScannerState();
  }

  Future<void> handleQrCapture(capture) async {
    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      final promoCode = barcode.rawValue;

      print('Promo QR code scanned: $promoCode');

      // Todo: validate payment hash

      // Todo: fetch promo info
      try {} catch (e) {
        print(e);
        // Todo: set error while validating payment hash/ fetching promo info
        rethrow;
      }

      print('SETTING STATE');
      state = state.copyWith(
        promoCode: promoCode,
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
      break;
    }
  }
}
