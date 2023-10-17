import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kumuly_pocket/enums/mnemonic_language.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:flutter_bip39/flutter_bip39.dart' as bip39;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mnemonic_repository.g.dart';

@riverpod
MnemonicRepository secureStorageMnemonicRepository(
    SecureStorageMnemonicRepositoryRef ref) {
  final secureStorage = ref.read(secureStorageProvider);
  return SecureStorageMnemonicRepository(secureStorage);
}

abstract class MnemonicRepository {
  Future<List<String>> newMnemonicWords(
    MnemonicLanguage language,
  );
  Future<Uint8List> wordsToSeed(List<String> mnemonicWords);
  Future<void> saveWords(String id, List<String> words);
  Future<List<String>> getWords(String id);
  Future<void> deleteWords(String id);
}

class SecureStorageMnemonicRepository implements MnemonicRepository {
  const SecureStorageMnemonicRepository(this._secureStorage);

  final FlutterSecureStorage _secureStorage;
  static const _mnemonicKeyPrefix = 'mnemonic_';

  @override
  Future<List<String>> newMnemonicWords(
    MnemonicLanguage language,
  ) async {
    final mnemonic = await bip39.generateIn(
      language.bip39Language,
      bip39.WordCount.Words12,
    );

    return mnemonic.words;
  }

  @override
  Future<Uint8List> wordsToSeed(List<String> mnemonicWords) async {
    final mnemonic = await bip39.parse(mnemonicWords);
    return await mnemonic.toSeed(passphrase: '');
  }

  @override
  Future<void> saveWords(String id, List<String> words) async {
    final key = '$_mnemonicKeyPrefix$id';
    // Check if it already exists.
    final existingMnemonic = await _secureStorage.containsKey(key: key);
    if (existingMnemonic) {
      throw Exception('Mnemonic already exists for id $id');
    }
    // Store the mnemonic in the secure storage.
    await _secureStorage.write(key: key, value: jsonEncode(words));
  }

  @override
  Future<List<String>> getWords(String id) async {
    // Todo: implement decryption with pin
    final key = '$_mnemonicKeyPrefix$id';
    if (!(await _secureStorage.containsKey(key: key))) {
      throw Exception('Mnemonic does not exist for id $id');
    }

    final mnemonicWordsString = await _secureStorage.read(key: key);
    if (mnemonicWordsString == null) {
      throw Exception('Mnemonic does not exist for id $id');
    }
    return List<String>.from(jsonDecode(mnemonicWordsString));
  }

  @override
  Future<void> deleteWords(String id) async {
    final key = '$_mnemonicKeyPrefix$id';

    if (!(await _secureStorage.containsKey(key: key))) {
      throw Exception('Mnemonic does not exist for id $id');
    }

    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      throw Exception('Failed to delete mnemonic.');
    }
  }
}
