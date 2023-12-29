import 'package:kumuly_pocket/entities/auth_user_entity.dart';
import 'package:kumuly_pocket/repositories/firebase_auth_repository.dart';
import 'package:kumuly_pocket/repositories/lightning_auth_repository.dart';
import 'package:kumuly_pocket/repositories/lightning_node_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_service.g.dart';

// Todo: use entities instead of view models in service classes
@riverpod
AuthenticationService firebaseAuthenticationService(
    FirebaseAuthenticationServiceRef ref) {
  final firebaseAuthRepository = ref.watch(firebaseAuthRepositoryImplProvider);
  final lightningAuthRepository =
      ref.watch(firebaseLightningAuthRepositoryProvider);
  final lightningNodeRepository =
      ref.watch(breezeSdkLightningNodeRepositoryProvider);

  return FirebaseLightningMessageAuthenticationService(
    firebaseAuthRepository,
    lightningAuthRepository,
    lightningNodeRepository,
  );
}

abstract class AuthenticationService {
  Stream<AuthUserEntity> get authUser;
  Future<void> logIn();
  Future<void> logOut();
}

class FirebaseLightningMessageAuthenticationService
    implements AuthenticationService {
  FirebaseLightningMessageAuthenticationService(
    this._firebaseAuthRepository,
    this._lightningAuthRepository,
    this._lightningNodeRepository,
  );

  final FirebaseAuthRepository _firebaseAuthRepository;

  final LightningAuthRepository _lightningAuthRepository;
  final LightningNodeRepository _lightningNodeRepository;

  @override
  Stream<AuthUserEntity> get authUser {
    return _firebaseAuthRepository.authUser
        //.distinct((prev, next) => prev.id == next.id)
        .map((authUser) {
      return authUser;
    }).asBroadcastStream();
  }

  @override
  Future<void> logIn() async {
    // Get the sign in message from the server.
    print("LOG IN");
    final signInMessage = await _lightningAuthRepository.getSignInMessage();
    print("SIGN IN MESSAGE: ${signInMessage.message}");

    // Sign the message.
    final signature =
        await _lightningNodeRepository.signMessage(signInMessage.message);
    final nodeId = await _lightningNodeRepository.nodeId;

    // Send the signature to the server.
    final jwt = await _lightningAuthRepository.getJwtForValidSignature(
      signInMessage.id,
      signature,
      nodeId,
    );
    // Login to firebase with the jwt.
    await _firebaseAuthRepository.signInWithCustomToken(jwt);
  }

  @override
  Future<void> logOut() async {
    print('Logging out...');
    await _firebaseAuthRepository.logOut();
  }
}
