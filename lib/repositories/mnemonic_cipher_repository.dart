import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mnemonic_cipher_repository.g.dart';

abstract class MnemonicCipherRepository {
  Future<void> setMnemonicCipher(String mnemonicCipher);
  Future<String> getMnemonicCipher();
  Future<void> deleteMnemonicCipher();
}

@riverpod
MnemonicCipherRepository secureStorageMnemonicCipherRepository(
    SecureStorageMnemonicCipherRepositoryRef ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return SecureStorageMnemonicCipherRepository(secureStorage);
}

class SecureStorageMnemonicCipherRepository
    implements MnemonicCipherRepository {
  const SecureStorageMnemonicCipherRepository(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  static const _kMnemonicCipherKey = 'mnemonic-cipher';

  @override
  Future<void> setMnemonicCipher(String mnemonic) async {
    await _secureStorage.write(key: _kMnemonicCipherKey, value: mnemonic);
  }

  @override
  Future<String> getMnemonicCipher() async {
    if (!(await _secureStorage.containsKey(key: _kMnemonicCipherKey))) {
      throw Exception('Mnemonic does not exist');
    }

    final mnemonic = await _secureStorage.read(key: _kMnemonicCipherKey);
    if (mnemonic == null || mnemonic.isEmpty) {
      throw Exception('Mnemonic does not exist');
    }
    return mnemonic;
  }

  @override
  Future<void> deleteMnemonicCipher() async {
    await _secureStorage.delete(key: _kMnemonicCipherKey);
  }
}
