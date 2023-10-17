import 'package:kumuly_pocket/entities/product_entity.dart';
import 'package:kumuly_pocket/entities/promo_entity.dart';
import 'package:kumuly_pocket/enums/visibility.dart';
import 'package:kumuly_pocket/repositories/product_repository.dart';
import 'package:kumuly_pocket/repositories/promo_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'promo_service.g.dart';

@riverpod
PromoService firebasePromoService(FirebasePromoServiceRef ref) {
  final promoRepository = ref.watch(firebasePromoRepositoryProvider);
  final productRepository = ref.watch(firebaseProductRepositoryProvider);

  return FirebasePromoService(
    promoRepository: promoRepository,
    productRepository: productRepository,
  );
}

abstract class PromoService {
  Future<void> createPromo(PromoEntity promo);
  Future<void> publishPromo(String merchantId, String promoId);
}

class FirebasePromoService implements PromoService {
  FirebasePromoService(
      {required this.promoRepository, required this.productRepository});

  final PromoRepository promoRepository;
  final ProductRepository productRepository;

  @override
  Future<void> createPromo(PromoEntity promo) async {
    final imageUrls = [''];
    const lnurlPayLink = '';

    // Fetch all product entities asynchronously
    List<ProductEntity>? productEntities;
    if (promo.products != null) {
      productEntities = await Future.wait(promo.products!.map(
        (product) async {
          final productEntity = await productRepository.get(product.id!);
          if (productEntity == null) {
            throw Exception('Product not found for ID: ${product.id}');
          }
          return productEntity;
        },
      ));
    }

    await promoRepository.addPromo(
      PromoEntity(
        description: promo.description,
        price: promo.price,
        lnurlPayLink: lnurlPayLink,
        imageUrls: imageUrls,
        expiryDate: promo.expiryDate,
        visibility: promo.visibility,
        merchantId: promo.merchantId,
        products: productEntities,
      ),
    );
  }

  @override
  Future<void> publishPromo(merchantId, String promoId) async {
    await promoRepository.updatePromoFields(
      merchantId,
      promoId,
      {
        'visibility': Visibility.public.stringValue,
      },
    );
  }
}
