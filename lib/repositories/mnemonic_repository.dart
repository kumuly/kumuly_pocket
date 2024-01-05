import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/entities/mnemonic_entity.dart';
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
  Future<List<String>> generate(
    MnemonicLanguage language,
  );
  Future<void> set(MnemonicEntity mnemonic);
  Future<List<String>> getWords();
  Future<MnemonicLanguage> getLanguage();
  Future<Uint8List> getSeed();
  Uint8List mnemonicToSeed(
    MnemonicEntity mnemonic,
  );
}

class SecureStorageMnemonicRepository implements MnemonicRepository {
  const SecureStorageMnemonicRepository(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  @override
  Future<List<String>> generate(
    MnemonicLanguage language,
  ) async {
    // Generate a new mnemonic
    final mnemonic = bip39.Mnemonic.generate(
      language.bip39Language,
      entropyLength: kSeedEntropyLength,
    );

    return mnemonic.words;
  }

  @override
  Future<void> set(MnemonicEntity mnemonic) async {
    try {
      bip39.Mnemonic.fromSentence(
        mnemonic.words.join(mnemonic.language.bip39Language.separator),
        mnemonic.language.bip39Language,
      );
    } catch (e) {
      print(e);
      throw InvalidSeedException(e.toString());
    }

    final mnemonicWordsString = jsonEncode(mnemonic.words);

    // Store the mnemonic and the language in secure storage.
    // Todo: implement encryption with pin
    await Future.wait([
      _secureStorage.write(key: kMnemonicKey, value: mnemonicWordsString),
      _secureStorage.write(
        key: kMnemonicLanguageKey,
        value: mnemonic.language.name,
      ),
    ]);
  }

  @override
  Future<List<String>> getWords() async {
    // Todo: implement decryption with pin
    if (!(await _secureStorage.containsKey(key: kMnemonicKey))) {
      throw Exception('Mnemonic does not exist');
    }

    final mnemonicWordsString = await _secureStorage.read(key: kMnemonicKey);
    if (mnemonicWordsString == null || mnemonicWordsString.isEmpty) {
      throw Exception('Mnemonic does not exist');
    }
    return List<String>.from(jsonDecode(mnemonicWordsString));
  }

  @override
  Future<MnemonicLanguage> getLanguage() async {
    final languageString = await _secureStorage.read(key: kMnemonicLanguageKey);
    if (languageString == null) {
      throw Exception('Mnemonic language does not exist');
    }
    return MnemonicLanguage.values.firstWhere(
      (language) => language.name == languageString,
    );
  }

  @override
  Future<Uint8List> getSeed() async {
    final words = await getWords();
    final language = await getLanguage();
    return mnemonicToSeed(MnemonicEntity(words: words, language: language));
  }

  @override
  Uint8List mnemonicToSeed(
    MnemonicEntity mnemonic,
  ) {
    final bip39Mnemonic = bip39.Mnemonic.fromSentence(
      mnemonic.words.join(mnemonic.language.bip39Language.separator),
      mnemonic.language.bip39Language,
    );
    final hexSeed = hex.encode(bip39Mnemonic.seed);

    final length = hexSeed.length;
    final bytes = Uint8List(length ~/ 2);

    for (var i = 0; i < length; i += 2) {
      final byte = int.parse(hexSeed.substring(i, i + 2), radix: 16);
      bytes[i ~/ 2] = byte;
    }

    return bytes;
  }
}

class InvalidSeedException implements Exception {
  InvalidSeedException(this.message);

  final String message;
}
