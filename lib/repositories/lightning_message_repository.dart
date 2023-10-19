import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/providers/firebase_providers.dart';
import 'package:kumuly_pocket/entities/sign_in_message_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lightning_message_repository.g.dart';

@riverpod
LightningMessageRepository firebaseLightningMessageRepository(
    FirebaseLightningMessageRepositoryRef ref) {
  final functions = ref.watch(firebaseFunctionsProvider);
  return FirebaseLightningMessageRepository(
    functions: functions,
  );
}

abstract class LightningMessageRepository {
  Future<SignInMessageEntity> getSignInMessage();
  Future<String> getJwtForValidSignature(
    String signInMessageId,
    String signature,
    String nodeId,
  );
}

class FirebaseLightningMessageRepository implements LightningMessageRepository {
  FirebaseLightningMessageRepository({required this.functions});

  final FirebaseFunctions functions;

  @override
  Future<SignInMessageEntity> getSignInMessage() async {
    try {
      final response = await functions
          .httpsCallable(
            'auth-generateSignInMessage',
            options: HttpsCallableOptions(
              limitedUseAppCheckToken: true,
            ),
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
        options: HttpsCallableOptions(
          limitedUseAppCheckToken: true,
        ),
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
