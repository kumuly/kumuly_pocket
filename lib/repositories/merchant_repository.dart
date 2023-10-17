import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/entities/merchant_entity.dart';
import 'package:kumuly_pocket/providers/firebase_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'merchant_repository.g.dart';

@riverpod
MerchantRepository firebaseMerchantRepository(
    FirebaseMerchantRepositoryRef ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  final functions = ref.read(firebaseFunctionsProvider);

  return FirebaseMerchantRepository(
    firestore: firestore,
    functions: functions,
  );
}

abstract class MerchantRepository {
  Stream<MerchantEntity?> getMerchantEntityStream(String id);
  Future<void> registerMerchant({
    required String id,
    required MerchantEntity merchant,
  });
  Future<MerchantEntity?> get(String id);
  Future<void> updateMerchantFields(
      String id, Map<String, dynamic> fieldsToUpdate);
  Future<void> mergeMerchant(String id, MerchantEntity merchantEntity);
  Future<void> createMerchantWallet(String id);
  Future<int> getMerchantWalletBalance(String id);
}

class FirebaseMerchantRepository implements MerchantRepository {
  FirebaseMerchantRepository({
    required this.firestore,
    required this.functions,
  });

  final FirebaseFirestore firestore;
  final FirebaseFunctions functions;
  final CollectionReference merchantsRef =
      FirebaseFirestore.instance.collection(merchantsCollection);

  @override
  Stream<MerchantEntity?> getMerchantEntityStream(String id) {
    if (id.isEmpty) return const Stream.empty();

    return merchantsRef
        .doc(
          id,
        )
        .snapshots()
        .map(
          (doc) => doc.exists ? MerchantEntity.fromDocumentSnapshot(doc) : null,
        );
  }

  @override
  Future<void> registerMerchant({
    required String id,
    required MerchantEntity merchant,
  }) {
    return merchantsRef.doc(id).set(merchant.toMapForCreation());
  }

  @override
  Future<MerchantEntity?> get(String id) async {
    final merchantDoc = await merchantsRef.doc(id).get();
    if (merchantDoc.exists) {
      return MerchantEntity.fromDocumentSnapshot(merchantDoc);
    } else {
      return null;
    }
  }

  @override
  Future<void> updateMerchantFields(
      String id, Map<String, dynamic> fieldsToUpdate) async {
    try {
      await merchantsRef.doc(id).update(fieldsToUpdate);
    } catch (e) {
      throw Exception('Failed to update merchant: $e');
    }
  }

  @override
  Future<void> mergeMerchant(String id, MerchantEntity merchantEntity) async {
    try {
      await merchantsRef
          .doc(id)
          .set(merchantEntity.toMapForUpdate(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to merge merchant: $e');
    }
  }

  @override
  Future<void> createMerchantWallet(String id) async {
    try {
      await functions
          .httpsCallable(
            'merchant-merchantWalletCreationHandler',
            options: HttpsCallableOptions(
              limitedUseAppCheckToken: true,
            ),
          )
          .call();
    } on FirebaseFunctionsException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<int> getMerchantWalletBalance(String id) async {
    try {
      final response = await functions
          .httpsCallable(
            'merchant-merchantWalletBalanceHandler',
            options: HttpsCallableOptions(
              limitedUseAppCheckToken: true,
            ),
          )
          .call();
      final balanceMsat = response.data as int;
      return balanceMsat ~/ 1000;
    } on FirebaseFunctionsException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
