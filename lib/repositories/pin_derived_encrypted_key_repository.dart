import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kumuly_pocket/entities/pin_derived_encryption_result_entity.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pin_derived_encrypted_key_repository.g.dart';

abstract class PinDerivedEncryptedKeyRepository {
  Future<void> setEncryptedKey(
    String label,
    PinDerivedEncryptionResultEntity encryptedKey,
  );
  Future<PinDerivedEncryptionResultEntity> getEncryptedKey(String label);
  Future<List<String>> getEncryptedKeyLabels();
}

@riverpod
PinDerivedEncryptedKeyRepository secureStoragePinDerivedEncryptedKeyRepository(
    SecureStoragePinDerivedEncryptedKeyRepositoryRef ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return SecureStoragePinDerivedEncryptedKeyRepository(secureStorage);
}

class SecureStoragePinDerivedEncryptedKeyRepository
    implements PinDerivedEncryptedKeyRepository {
  const SecureStoragePinDerivedEncryptedKeyRepository(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  static const _kPinDerivedEncryptedKeyKeyPrefix = 'pin-derived-encrypted-key-';

  @override
  Future<void> setEncryptedKey(
    String label,
    PinDerivedEncryptionResultEntity encryptionKeyData,
  ) async {
    await _secureStorage.write(
      key: '$_kPinDerivedEncryptedKeyKeyPrefix$label',
      value: jsonEncode(encryptionKeyData),
    );
  }

  @override
  Future<PinDerivedEncryptionResultEntity> getEncryptedKey(String label) async {
    final key = '$_kPinDerivedEncryptedKeyKeyPrefix$label';
    if (!(await _secureStorage.containsKey(key: key))) {
      throw Exception('Encrypted key does not exist');
    }

    final encryptionKeyDataJsonString = await _secureStorage.read(
      key: key,
    );
    if (encryptionKeyDataJsonString == null ||
        encryptionKeyDataJsonString.isEmpty) {
      throw Exception('Encrypted key does not exist');
    }
    return PinDerivedEncryptionResultEntity.fromJson(
      jsonDecode(encryptionKeyDataJsonString) as Map<String, dynamic>,
    );
  }

  @override
  Future<List<String>> getEncryptedKeyLabels() async {
    final allKeys = await _secureStorage.readAll();
    return allKeys.keys
        .where((key) => key.startsWith(_kPinDerivedEncryptedKeyKeyPrefix))
        .map((key) => key.substring(_kPinDerivedEncryptedKeyKeyPrefix.length))
        .toList();
  }
}
