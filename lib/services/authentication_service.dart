import 'package:kumuly_pocket/entities/account_entity.dart';
import 'package:kumuly_pocket/repositories/authentication_repository.dart';
import 'package:kumuly_pocket/repositories/lightning_message_repository.dart';
import 'package:kumuly_pocket/repositories/lightning_node_repository.dart';
import 'package:kumuly_pocket/repositories/account_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_service.g.dart';

// Todo: use entities instead of view models in service classes
@riverpod
AuthenticationService firebaseAuthenticationService(
    FirebaseAuthenticationServiceRef ref) {
  final authenticationRepository =
      ref.watch(firebaseAuthenticationRepositoryProvider);
  final accountRepository =
      ref.watch(sharedPreferencesAccountRepositoryProvider);
  final lightningMessageRepository =
      ref.watch(firebaseLightningMessageRepositoryProvider);
  final lightningNodeRepository =
      ref.watch(breezeSdkLightningNodeRepositoryProvider);

  return FirebaseLightningMessageAuthenticationService(
    authenticationRepository,
    accountRepository,
    lightningMessageRepository,
    lightningNodeRepository,
  );
}

@riverpod
class ConnectedAccount extends _$ConnectedAccount {
  @override
  Stream<AccountEntity> build() {
    final authenticationService =
        ref.watch(firebaseAuthenticationServiceProvider);
    return authenticationService.connectedAccount;
  }
}

abstract class AuthenticationService {
  Stream<AccountEntity> get connectedAccount;
  Future<void> logIn(String nodeId);
  Future<void> logOut();
}

class FirebaseLightningMessageAuthenticationService
    implements AuthenticationService {
  FirebaseLightningMessageAuthenticationService(
    this._authenticationRepository,
    this._accountRepository,
    this._lightningMessageRepository,
    this._lightningNodeRepository,
  );

  final AuthenticationRepository _authenticationRepository;
  final AccountRepository _accountRepository;
  final LightningMessageRepository _lightningMessageRepository;
  final LightningNodeRepository _lightningNodeRepository;

  @override
  Stream<AccountEntity> get connectedAccount {
    return _authenticationRepository.authUser
        //.distinct((prev, next) => prev.id == next.id)
        .map((authUser) {
      print('connectedAccount rebuild');
      if (authUser.isEmpty) {
        return AccountEntity.empty;
      } else {
        return _accountRepository.get(authUser.id);
      }
    }).asBroadcastStream();
  }

  @override
  Future<void> logIn(String nodeId) async {
    // Get the sign in message from the server.
    final signInMessage = await _lightningMessageRepository.getSignInMessage();

    // Sign the message.
    final signature =
        await _lightningNodeRepository.signMessage(signInMessage.message);

    // Send the signature to the server.
    final jwt = await _lightningMessageRepository.getJwtForValidSignature(
      signInMessage.id,
      signature,
      nodeId,
    );
    // Login to firebase with the jwt.
    await _authenticationRepository.signInWithCustomToken(jwt);

    // Save the last login time for the user.
    final user =
        _accountRepository.get(nodeId).copyWith(lastLogin: DateTime.now());
    await _accountRepository.save(user);
  }

  @override
  Future<void> logOut() async {
    print('Logging out...');
    await _authenticationRepository.logOut();
    print('Disconnecting breez node');
    await _lightningNodeRepository.disconnect();
  }
}
