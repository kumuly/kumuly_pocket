import 'package:firebase_auth/firebase_auth.dart';
import 'package:kumuly_pocket/entities/auth_user_entity.dart';
import 'package:kumuly_pocket/providers/firebase_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_repository.g.dart';

@riverpod
AuthenticationRepository firebaseAuthenticationRepository(
    FirebaseAuthenticationRepositoryRef ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthenticationRepository(firebaseAuth);
}

abstract class AuthenticationRepository {
  Stream<AuthUserEntity> get authUser;
  Future<void> signInWithCustomToken(String token);
  Future<void> logOut();
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

class FirebaseAuthenticationRepository implements AuthenticationRepository {
  FirebaseAuthenticationRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  /// Stream of [AuthUserEntity] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [AuthUserEntity.empty] if the user is not authenticated.
  @override
  Stream<AuthUserEntity> get authUser {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      print('authUser rebuild');
      final authUserEntity = firebaseUser == null
          ? AuthUserEntity.empty
          : AuthUserEntity.fromFirebaseAuthUser(firebaseUser);
      return authUserEntity;
    });
  }

  @override
  Future<void> signInWithCustomToken(String token) async {
    try {
      await _firebaseAuth.signInWithCustomToken(token);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Signs out the current user which will emit
  /// [AuthUserEntity.empty] from the [userEntity] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  @override
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }
}
