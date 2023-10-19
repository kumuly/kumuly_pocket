import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/entities/product_entity.dart';
import 'package:kumuly_pocket/providers/firebase_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_repository.g.dart';

@riverpod
ProductRepository firebaseProductRepository(FirebaseProductRepositoryRef ref) {
  return FirebaseProductRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
    functions: ref.watch(firebaseFunctionsProvider),
  );
}

abstract class ProductRepository {
  Future<void> addProduct(
    ProductEntity product,
  );
  Future<void> createProductPaylink(String id);
  Future<ProductEntity?> get(String id);
  Future<void> updateProductFields(
      String merchantId, String productId, Map<String, dynamic> fieldsToUpdate);
  Future<void> mergeProduct(String productId, ProductEntity productEntity);
}

class FirebaseProductRepository implements ProductRepository {
  FirebaseProductRepository({
    required this.firestore,
    required this.functions,
  });

  final FirebaseFirestore firestore;
  final FirebaseFunctions functions;
  final CollectionReference merchantsRef =
      FirebaseFirestore.instance.collection(merchantsCollection);
  final CollectionReference allProductsRef =
      FirebaseFirestore.instance.collection(allProductsCollection);

  @override
  Future<void> addProduct(ProductEntity product) async {
    final productDocData = product.toMapForCreation();
    final allProductsDoc = await allProductsRef.add(productDocData);
    return merchantsRef
        .doc(product.merchantId)
        .collection(productsSubcollection)
        .doc(allProductsDoc.id)
        .set(product.toMapForCreation());
  }

  @override
  Future<void> createProductPaylink(String id) {
    // TODO: implement createProductPaylink
    throw UnimplementedError();
  }

  @override
  Future<ProductEntity?> get(String id) async {
    final productDoc = await allProductsRef.doc(id).get();
    if (productDoc.exists) {
      return ProductEntity.fromDocumentSnapshot(productDoc);
    } else {
      return null;
    }
  }

  @override
  Future<void> updateProductFields(
    String merchantId,
    String productId,
    Map<String, dynamic> fieldsToUpdate,
  ) async {
    await Future.wait([
      allProductsRef.doc(productId).update(fieldsToUpdate),
      merchantsRef
          .doc(merchantId)
          .collection(productsSubcollection)
          .doc(productId)
          .update(fieldsToUpdate),
    ]);
  }

  /// Merge Product with existing Product, maintaining the existing Product's fields,
  ///   overwriting with the new Product's fields if they conflict
  ///   and adding new fields if they don't exist.
  @override
  Future<void> mergeProduct(
    String productId,
    ProductEntity productEntity,
  ) async {
    await Future.wait([
      allProductsRef
          .doc(productId)
          .set(productEntity.toMapForUpdate(), SetOptions(merge: true)),
      merchantsRef
          .doc(productEntity.merchantId)
          .collection(productsSubcollection)
          .doc(productId)
          .set(productEntity.toMapForUpdate(), SetOptions(merge: true))
    ]);
  }
}
