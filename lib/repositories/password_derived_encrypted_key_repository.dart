import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kumuly_pocket/entities/password_derived_encryption_result_entity.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'password_derived_encrypted_key_repository.g.dart';

abstract class PasswordDerivedEncryptedKeyRepository {
  Future<void> setEncryptedKey(
    String label,
    PasswordDerivedEncryptionResultEntity encryptedKey,
  );
  Future<PasswordDerivedEncryptionResultEntity> getEncryptedKey(String label);
  Future<List<String>> getEncryptedKeyLabels();
}

@riverpod
PasswordDerivedEncryptedKeyRepository
    secureStoragePasswordDerivedEncryptedKeyRepository(
        SecureStoragePasswordDerivedEncryptedKeyRepositoryRef ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return SecureStoragePasswordDerivedEncryptedKeyRepository(secureStorage);
}

class SecureStoragePasswordDerivedEncryptedKeyRepository
    implements PasswordDerivedEncryptedKeyRepository {
  const SecureStoragePasswordDerivedEncryptedKeyRepository(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  static const _kPasswordDerivedEncryptedKeyKeyPrefix =
      'password-derived-encrypted-key-';

  @override
  Future<void> setEncryptedKey(
    String label,
    PasswordDerivedEncryptionResultEntity encryptionKeyData,
  ) async {
    await _secureStorage.write(
      key: '$_kPasswordDerivedEncryptedKeyKeyPrefix$label',
      value: jsonEncode(encryptionKeyData),
    );
  }

  @override
  Future<PasswordDerivedEncryptionResultEntity> getEncryptedKey(
      String label) async {
    final key = '$_kPasswordDerivedEncryptedKeyKeyPrefix$label';
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
    return PasswordDerivedEncryptionResultEntity.fromJson(
      jsonDecode(encryptionKeyDataJsonString) as Map<String, dynamic>,
    );
  }

  @override
  Future<List<String>> getEncryptedKeyLabels() async {
    final allKeys = await _secureStorage.readAll();
    return allKeys.keys
        .where((key) => key.startsWith(_kPasswordDerivedEncryptedKeyKeyPrefix))
        .map((key) =>
            key.substring(_kPasswordDerivedEncryptedKeyKeyPrefix.length))
        .toList();
  }
}
