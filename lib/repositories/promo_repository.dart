import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/entities/promo_entity.dart';
import 'package:kumuly_pocket/providers/firebase_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'promo_repository.g.dart';

@riverpod
PromoRepository firebasePromoRepository(FirebasePromoRepositoryRef ref) {
  return FirebasePromoRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
    functions: ref.watch(firebaseFunctionsProvider),
  );
}

abstract class PromoRepository {
  Future<void> addPromo(
    PromoEntity promo,
  );
  Future<void> createPromoPaylink(String id);
  Future<PromoEntity?> get(String id);
  Future<void> updatePromoFields(
    String merchantId,
    String promoId,
    Map<String, dynamic> fieldsToUpdate,
  );
  Future<void> mergePromo(
    String promoId,
    PromoEntity promoEntity,
  );
}

class FirebasePromoRepository implements PromoRepository {
  FirebasePromoRepository({
    required this.firestore,
    required this.functions,
  });

  final FirebaseFirestore firestore;
  final FirebaseFunctions functions;
  final CollectionReference merchantsRef =
      FirebaseFirestore.instance.collection(merchantsCollection);
  final CollectionReference allPromosRef =
      FirebaseFirestore.instance.collection(allPromosCollection);

  @override
  Future<void> addPromo(PromoEntity promo) async {
    final promoDocData = promo.toMapForCreation();
    final allPromosDoc = await allPromosRef.add(promoDocData);
    return merchantsRef
        .doc(promo.merchantId)
        .collection(promosSubcollection)
        .doc(allPromosDoc.id)
        .set(promo.toMapForCreation());
  }

  @override
  Future<void> createPromoPaylink(String id) {
    // TODO: implement createPromoPaylink
    throw UnimplementedError();
  }

  @override
  Future<PromoEntity?> get(String id) async {
    final promoDoc = await allPromosRef.doc(id).get();
    if (promoDoc.exists) {
      return PromoEntity.fromDocumentSnapshot(promoDoc);
    } else {
      return null;
    }
  }

  /// Update Promo with new fields, overwriting existing Promo's fields.
  @override
  Future<void> updatePromoFields(
    String merchantId,
    String promoId,
    Map<String, dynamic> fieldsToUpdate,
  ) async {
    await Future.wait([
      allPromosRef.doc(promoId).update(fieldsToUpdate),
      merchantsRef
          .doc(merchantId)
          .collection(promosSubcollection)
          .doc(promoId)
          .update(fieldsToUpdate),
    ]);
  }

  /// Merge Promo with existing Promo, maintaining the existing Promo's fields,
  ///   overwriting with the new Promo's fields if they conflict
  ///   and adding new fields if they don't exist.
  @override
  Future<void> mergePromo(
    String promoId,
    PromoEntity promoEntity,
  ) async {
    await Future.wait([
      allPromosRef
          .doc(promoId)
          .set(promoEntity.toMapForUpdate(), SetOptions(merge: true)),
      merchantsRef
          .doc(promoEntity.merchantId)
          .collection(promosSubcollection)
          .doc(promoId)
          .set(promoEntity.toMapForUpdate(), SetOptions(merge: true))
    ]);
  }
}
