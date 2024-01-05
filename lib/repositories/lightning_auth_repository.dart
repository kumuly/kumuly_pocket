import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/providers/firebase_providers.dart';
import 'package:kumuly_pocket/entities/sign_in_message_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lightning_auth_repository.g.dart';

@riverpod
LightningAuthRepository firebaseLightningAuthRepository(
    FirebaseLightningAuthRepositoryRef ref) {
  final functions = ref.watch(firebaseFunctionsProvider);
  return FirebaseLightningAuthRepository(
    functions: functions,
  );
}

abstract class LightningAuthRepository {
  Future<SignInMessageEntity> getSignInMessage();
  Future<String> getJwtForValidSignature(
    String signInMessageId,
    String signature,
    String nodeId,
  );
}

class FirebaseLightningAuthRepository implements LightningAuthRepository {
  FirebaseLightningAuthRepository({required this.functions});

  final FirebaseFunctions functions;

  @override
  Future<SignInMessageEntity> getSignInMessage() async {
    try {
      final response = await functions
          .httpsCallable(
            'auth-generateSignInMessage',
            options: HttpsCallableOptions(),
          )
          .call();
      final data = response.data as Map<String, dynamic>;
      return SignInMessageEntity.fromMap(data);
    } on FirebaseFunctionsException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> getJwtForValidSignature(
    String signInMessageId,
    String signature,
    String nodeId,
  ) async {
    try {
      final response = await functions
          .httpsCallable(
        'auth-authenticateNode',
        options: HttpsCallableOptions(),
      )
          .call(
        {
          'signInMessageId': signInMessageId,
          'signature': signature,
          'nodeId': nodeId,
        },
      );

      return response.data['jwt'] as String;
    } on FirebaseFunctionsException catch (e) {
      if (kDebugMode) {
        print(e.message);
        print(e.code);
        print(e.details);
      }
      throw Exception(e.message);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception(e.toString());
    }
  }
}
