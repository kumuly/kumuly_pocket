import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kumuly_pocket/entities/encryption_result_entity.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'encrypted_mnemonic_repository.g.dart';

abstract class EncryptedMnemonicRepository {
  Future<void> setEncryptedMnemonic(
    String label,
    EncryptionResultEntity encryptedMnemonic,
  );
  Future<EncryptionResultEntity> getEncryptedMnemonic(String label);
  Future<List<String>> getEncryptedMnemonicLabels();
  Future<void> deleteEncryptedMnemonic(String label);
}

@riverpod
EncryptedMnemonicRepository secureStorageEncryptedMnemonicRepository(
    SecureStorageEncryptedMnemonicRepositoryRef ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return SecureStorageEncryptedMnemonicRepository(secureStorage);
}

class SecureStorageEncryptedMnemonicRepository
    implements EncryptedMnemonicRepository {
  const SecureStorageEncryptedMnemonicRepository(this._secureStorage);

  final FlutterSecureStorage _secureStorage;
  static const _kEncryptedMnemonicKeyPrefix = 'encrypted-mnemonic-';

  @override
  Future<void> setEncryptedMnemonic(
    String label,
    EncryptionResultEntity encryptedMnemonic,
  ) async {
    await _secureStorage.write(
      key: '$_kEncryptedMnemonicKeyPrefix$label',
      value: jsonEncode(encryptedMnemonic),
    );
  }

  @override
  Future<EncryptionResultEntity> getEncryptedMnemonic(String label) async {
    final key = '$_kEncryptedMnemonicKeyPrefix$label';
    if (!(await _secureStorage.containsKey(key: key))) {
      throw Exception('Mnemonic does not exist');
    }

    final mnemonicJsonString = await _secureStorage.read(key: key);
    if (mnemonicJsonString == null || mnemonicJsonString.isEmpty) {
      throw Exception('Mnemonic does not exist');
    }
    return EncryptionResultEntity.fromJson(
      jsonDecode(mnemonicJsonString) as Map<String, dynamic>,
    );
  }

  @override
  Future<List<String>> getEncryptedMnemonicLabels() async {
    final allKeys = await _secureStorage.readAll();
    return allKeys.keys
        .where((key) => key.startsWith(_kEncryptedMnemonicKeyPrefix))
        .map((key) => key.substring(_kEncryptedMnemonicKeyPrefix.length))
        .toList();
  }

  @override
  Future<void> deleteEncryptedMnemonic(String label) async {
    await _secureStorage.delete(key: '$_kEncryptedMnemonicKeyPrefix$label');
  }
}
