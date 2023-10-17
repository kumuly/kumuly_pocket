import 'package:kumuly_pocket/entities/product_entity.dart';
import 'package:kumuly_pocket/enums/visibility.dart';
import 'package:kumuly_pocket/repositories/product_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_service.g.dart';

@riverpod
ProductService firebaseProductService(FirebaseProductServiceRef ref) {
  final productRepository = ref.watch(firebaseProductRepositoryProvider);

  return FirebaseProductService(
    productRepository: productRepository,
  );
}

abstract class ProductService {
  Future<void> addProduct(ProductEntity product);
  Future<void> publishProduct(String merchantId, String productId);
}

class FirebaseProductService implements ProductService {
  FirebaseProductService({required this.productRepository});

  final ProductRepository productRepository;

  @override
  Future<void> addProduct(ProductEntity product) async {
    final imageUrls = [
      ''
    ]; // Todo: await productRepository.uploadProductImages(product.images!);
    const lnurlPayLink =
        ''; // Todo: await productRepository.createProductPaylink(...);
    await productRepository.addProduct(
      product,
    );
  }

  @override
  Future<void> publishProduct(merchantId, String productId) async {
    await productRepository.updateProductFields(
      merchantId,
      productId,
      {
        'visibility': Visibility.public.stringValue,
      },
    );
  }
}
