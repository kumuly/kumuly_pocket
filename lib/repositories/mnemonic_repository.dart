import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kumuly_pocket/enums/mnemonic_language.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:bip39_mnemonic/bip39_mnemonic.dart' as bip39;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mnemonic_repository.g.dart';

@riverpod
MnemonicRepository secureStorageMnemonicRepository(
    SecureStorageMnemonicRepositoryRef ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return SecureStorageMnemonicRepository(secureStorage);
}

abstract class MnemonicRepository {
  List<String> newMnemonicWords(
    MnemonicLanguage language,
  );
  Uint8List wordsToSeed(
    List<String> mnemonicWords,
    MnemonicLanguage language,
  );
  Future<void> saveWords(String id, List<String> words);
  Future<List<String>> getWords(String id);
  Future<void> deleteWords(String id);
}

class SecureStorageMnemonicRepository implements MnemonicRepository {
  const SecureStorageMnemonicRepository(this._secureStorage);

  final FlutterSecureStorage _secureStorage;
  static const _mnemonicKeyPrefix = 'mnemonic_';

  @override
  List<String> newMnemonicWords(
    MnemonicLanguage language,
  ) {
    final mnemonic = bip39.Mnemonic.generate(
      language.bip39Language,
    );

    return mnemonic.words;
  }

  @override
  Uint8List wordsToSeed(
    List<String> mnemonicWords,
    MnemonicLanguage language,
  ) {
    final mnemonic = bip39.Mnemonic.fromSentence(
      mnemonicWords.join(language.bip39Language.separator),
      language.bip39Language,
    );
    final hexSeed = hex.encode(mnemonic.seed);

    final length = hexSeed.length;
    final bytes = Uint8List(length ~/ 2);

    for (var i = 0; i < length; i += 2) {
      final byte = int.parse(hexSeed.substring(i, i + 2), radix: 16);
      bytes[i ~/ 2] = byte;
    }

    return bytes;
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
