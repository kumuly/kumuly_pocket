import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:kumuly_pocket/entities/encryption_result_entity.dart';
import 'package:kumuly_pocket/entities/password_derived_encryption_result_entity.dart';
import 'package:kumuly_pocket/repositories/password_derived_encrypted_key_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cryptography/cryptography.dart';

part 'password_derived_encrypted_key_management_service.g.dart';

abstract class PasswordDerivedEncryptedKeyManagementService {
  Future<void> init(String password);
  Future<EncryptionResultEntity> encrypt(String plaintext, String password);
  Future<String> decrypt(
    EncryptionResultEntity encryptionResult,
    String password,
  );
  Future<bool> isPasswordValid(String password);
  Future<void> updatePassword(String oldPassword, String newPassword);
}

@riverpod
PasswordDerivedEncryptedKeyManagementService masterKeyManagementService(
    MasterKeyManagementServiceRef ref) {
  final encryptedMasterKeyRepository = ref.watch(
    secureStoragePasswordDerivedEncryptedKeyRepositoryProvider,
  );
  return MasterKeyManagementService(encryptedMasterKeyRepository);
}

class MasterKeyManagementService
    implements PasswordDerivedEncryptedKeyManagementService {
  final PasswordDerivedEncryptedKeyRepository _encryptedMasterKeyRepository;
  final _aesGcm = AesGcm.with256bits();
  static const _kByteLength = 32;
  static const kLabel = 'master';

  MasterKeyManagementService(this._encryptedMasterKeyRepository);

  @override
  Future<void> init(String password) async {
    final passwordSalt = _generateRandomBytes();
    final masterKey = _generateRandomBytes(); // Generate a new master key
    await _encryptAndStoreMasterKey(masterKey, password, passwordSalt);
  }

  @override
  Future<EncryptionResultEntity> encrypt(
    String plaintext,
    String password,
  ) async {
    // Get the master key
    final masterKey = await _getMasterKey(password);

    // Encrypt the plaintext with the master key
    final plaintextSecretBox = await _aesGcm.encrypt(
      utf8.encode(plaintext),
      secretKey: SecretKey(masterKey),
    );

    return EncryptionResultEntity(
      ciphertext: base64Encode(plaintextSecretBox.cipherText),
      iv: base64Encode(plaintextSecretBox.nonce),
      mac: base64Encode(plaintextSecretBox.mac.bytes),
    );
  }

  @override
  Future<String> decrypt(
    EncryptionResultEntity encryptionResult,
    String password,
  ) async {
    // Get the master key
    final masterKey = await _getMasterKey(password);

    // Decrypt the ciphertext with the master key
    final plaintextSecretBox = SecretBox(
      base64Decode(encryptionResult.ciphertext),
      nonce: base64Decode(encryptionResult.iv),
      mac: await _aesGcm.macAlgorithm.calculateMac(
        base64Decode(encryptionResult.mac!),
        secretKey: SecretKey(masterKey),
      ),
    );
    final plaintext = await _aesGcm.decrypt(
      plaintextSecretBox,
      secretKey: SecretKey(masterKey),
    );

    return utf8.decode(plaintext);
  }

  @override
  Future<bool> isPasswordValid(String password) async {
    // Try to decrypt the master key with the password
    try {
      await _getMasterKey(password);
      return true;
    } on SecretBoxAuthenticationError catch (_) {
      print('Invalid password');
      return false;
    } catch (_) {
      print('Other error');
      return false;
    }
  }

  @override
  Future<void> updatePassword(String oldPassword, String newPassword) async {
    final masterKey = await _getMasterKey(
        oldPassword); // Decrypt the master key with the old password
    final newPasswordSalt =
        _generateRandomBytes(); // Generate a new salt for the new password
    await _encryptAndStoreMasterKey(masterKey, newPassword, newPasswordSalt);
  }

  Uint8List _generateRandomBytes({int length = _kByteLength}) {
    final rng = Random.secure();
    final bytes = Uint8List(length);
    for (int i = 0; i < length; i++) {
      bytes[i] = rng.nextInt(256);
    }
    return bytes;
  }

  Future<SecretKey> _deriveKeyFromPassword(
    String password,
    Uint8List salt,
  ) async {
    final algorithm = Argon2id(
      parallelism: 4,
      memory: 1000,
      iterations: 1,
      hashLength: _kByteLength,
    );
    return algorithm.deriveKeyFromPassword(password: password, nonce: salt);
  }

  Future<List<int>> _getMasterKey(String password) async {
    // Get the encrypted master key data
    final encryptedKey =
        await _encryptedMasterKeyRepository.getEncryptedKey(kLabel);
    // Derive the encryption key from the password and salt
    final encryptionKey = await _deriveKeyFromPassword(
      password,
      base64Decode(encryptedKey.passwordSalt),
    );

    // Decrypt the master key with the encryption key
    final masterKeySecretBox = SecretBox(
      base64Decode(encryptedKey.encryptionResult.ciphertext),
      nonce: base64Decode(encryptedKey.encryptionResult.iv),
      mac: await _aesGcm.macAlgorithm.calculateMac(
        base64Decode(encryptedKey.encryptionResult.mac!),
        secretKey: encryptionKey,
      ),
    );
    final masterKey = await _aesGcm.decrypt(
      masterKeySecretBox,
      secretKey: encryptionKey,
    );

    return masterKey;
  }

  Future<void> _encryptAndStoreMasterKey(
    List<int> masterKey,
    String password,
    Uint8List salt,
  ) async {
    // Derive the encryption key from the password and salt
    final encryptionKey = await _deriveKeyFromPassword(password, salt);

    // Encrypt the master key with the derived encryption key
    final encryptedKeySecretBox = await _aesGcm.encrypt(
      masterKey,
      secretKey: encryptionKey,
    );

    // Prepare the encrypted master key data for storage
    final encryptedKeyData = PasswordDerivedEncryptionResultEntity(
      passwordSalt: base64Encode(salt),
      encryptionResult: EncryptionResultEntity(
        ciphertext: base64Encode(encryptedKeySecretBox.cipherText),
        iv: base64Encode(encryptedKeySecretBox.nonce),
        mac: base64Encode(encryptedKeySecretBox.mac.bytes),
      ),
    );

    // Store the encrypted master key data
    await _encryptedMasterKeyRepository.setEncryptedKey(
      kLabel,
      encryptedKeyData,
    );
  }
}
