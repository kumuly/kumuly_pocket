import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kumuly_pocket/entities/password_derived_encryption_result_entity.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'password_derived_encrypted_key_repository.g.dart';

abstract class PasswordDerivedEncryptedKeyRepository {
  Future<void> setEncryptedKey(
    PasswordDerivedEncryptionResultEntity encryptedKey,
  );
  Future<PasswordDerivedEncryptionResultEntity> getEncryptedKey();
}

@riverpod
PasswordDerivedEncryptedKeyRepository encryptedMasterKeyRepository(
    EncryptedMasterKeyRepositoryRef ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return EncryptedMasterKeyRepository(secureStorage);
}

class EncryptedMasterKeyRepository
    implements PasswordDerivedEncryptedKeyRepository {
  const EncryptedMasterKeyRepository(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  static const _kEncryptedMasterKeyKey = 'encrypted-master-key';

  @override
  Future<void> setEncryptedKey(
    PasswordDerivedEncryptionResultEntity encryptionKeyData,
  ) async {
    await _secureStorage.write(
      key: _kEncryptedMasterKeyKey,
      value: jsonEncode(encryptionKeyData),
    );
  }

  @override
  Future<PasswordDerivedEncryptionResultEntity> getEncryptedKey() async {
    if (!(await _secureStorage.containsKey(key: _kEncryptedMasterKeyKey))) {
      throw Exception('Encrypted key does not exist');
    }

    final encryptionKeyDataJsonString = await _secureStorage.read(
      key: _kEncryptedMasterKeyKey,
    );
    if (encryptionKeyDataJsonString == null ||
        encryptionKeyDataJsonString.isEmpty) {
      throw Exception('Encrypted key  does not exist');
    }
    return PasswordDerivedEncryptionResultEntity.fromJson(
      jsonDecode(encryptionKeyDataJsonString) as Map<String, dynamic>,
    );
  }
}
