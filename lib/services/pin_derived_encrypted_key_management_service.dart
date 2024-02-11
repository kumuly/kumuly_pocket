import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:kumuly_pocket/entities/encryption_result_entity.dart';
import 'package:kumuly_pocket/entities/pin_derived_encryption_result_entity.dart';
import 'package:kumuly_pocket/repositories/pin_derived_encrypted_key_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cryptography/cryptography.dart';

part 'pin_derived_encrypted_key_management_service.g.dart';

abstract class PinDerivedEncryptedKeyManagementService {
  Future<void> init(String pin);
  Future<EncryptionResultEntity> encrypt(String plaintext, String pin);
  Future<String> decrypt(
    EncryptionResultEntity encryptionResult,
    String pin,
  );
  Future<bool> isPinValid(String pin);
  Future<void> updatePin(String oldPin, String newPin);
}

@riverpod
Future<bool> checkPin(CheckPinRef ref, String pin) async {
  final masterKeyManagementService =
      ref.read(masterKeyManagementServiceProvider);
  return masterKeyManagementService.isPinValid(pin);
}

@riverpod
PinDerivedEncryptedKeyManagementService masterKeyManagementService(
    MasterKeyManagementServiceRef ref) {
  final encryptedMasterKeyRepository = ref.watch(
    secureStoragePinDerivedEncryptedKeyRepositoryProvider,
  );
  return MasterKeyManagementService(encryptedMasterKeyRepository);
}

class MasterKeyManagementService
    implements PinDerivedEncryptedKeyManagementService {
  final PinDerivedEncryptedKeyRepository _encryptedMasterKeyRepository;
  final _aesGcm = AesGcm.with256bits();
  static const _kByteLength = 32;
  static const kLabel = 'master';

  MasterKeyManagementService(this._encryptedMasterKeyRepository);

  @override
  Future<void> init(String pin) async {
    final pinSalt = _generateRandomBytes();
    final masterKey = _generateRandomBytes(); // Generate a new master key
    await _encryptAndStoreMasterKey(masterKey, pin, pinSalt);
  }

  @override
  Future<EncryptionResultEntity> encrypt(
    String plaintext,
    String pin,
  ) async {
    // Get the master key
    final masterKey = await _getMasterKey(pin);

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
    String pin,
  ) async {
    // Get the master key
    final masterKey = await _getMasterKey(pin);

    // Decrypt the ciphertext with the master key
    final plaintextSecretBox = SecretBox(
      base64Decode(encryptionResult.ciphertext),
      nonce: base64Decode(encryptionResult.iv),
      mac: Mac(base64Decode(encryptionResult.mac!)),
    );
    final plaintext = await _aesGcm.decrypt(
      plaintextSecretBox,
      secretKey: SecretKey(masterKey),
    );

    return utf8.decode(plaintext);
  }

  @override
  Future<bool> isPinValid(String pin) async {
    // Try to decrypt the master key with the pin
    try {
      await _getMasterKey(pin);
      return true;
    } on SecretBoxAuthenticationError catch (_) {
      print('Invalid pin');
      return false;
    } catch (_) {
      print('Other error');
      return false;
    }
  }

  @override
  Future<void> updatePin(String oldPin, String newPin) async {
    final masterKey =
        await _getMasterKey(oldPin); // Decrypt the master key with the old pin
    final newPinSalt =
        _generateRandomBytes(); // Generate a new salt for the new pin
    await _encryptAndStoreMasterKey(masterKey, newPin, newPinSalt);
  }

  Uint8List _generateRandomBytes({int length = _kByteLength}) {
    final rng = Random.secure();
    final bytes = Uint8List(length);
    for (int i = 0; i < length; i++) {
      bytes[i] = rng.nextInt(256);
    }
    return bytes;
  }

  Future<SecretKey> _deriveKeyFromPin(
    String pin,
    Uint8List salt,
  ) async {
    final algorithm = Argon2id(
      parallelism: 4,
      memory: 1000,
      iterations: 1,
      hashLength: _kByteLength,
    );
    return algorithm.deriveKeyFromPassword(password: pin, nonce: salt);
  }

  Future<List<int>> _getMasterKey(String pin) async {
    // Get the encrypted master key data
    final encryptedKey =
        await _encryptedMasterKeyRepository.getEncryptedKey(kLabel);
    // Derive the encryption key from the pin and salt
    final encryptionKey = await _deriveKeyFromPin(
      pin,
      base64Decode(encryptedKey.pinSalt),
    );

    // Decrypt the master key with the encryption key
    final masterKeySecretBox = SecretBox(
      base64Decode(encryptedKey.encryptionResult.ciphertext),
      nonce: base64Decode(encryptedKey.encryptionResult.iv),
      mac: Mac(base64Decode(encryptedKey.encryptionResult.mac!)),
    );
    final masterKey = await _aesGcm.decrypt(
      masterKeySecretBox,
      secretKey: encryptionKey,
    );

    return masterKey;
  }

  Future<void> _encryptAndStoreMasterKey(
    List<int> masterKey,
    String pin,
    Uint8List salt,
  ) async {
    // Derive the encryption key from the pin and salt
    final encryptionKey = await _deriveKeyFromPin(pin, salt);

    // Encrypt the master key with the derived encryption key
    final encryptedKeySecretBox = await _aesGcm.encrypt(
      masterKey,
      secretKey: encryptionKey,
    );

    // Prepare the encrypted master key data for storage
    final encryptedKeyData = PinDerivedEncryptionResultEntity(
      pinSalt: base64Encode(salt),
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
