import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:kumuly_pocket/repositories/mnemonic_cipher_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mnemonic_service.g.dart';

abstract class MnemonicService {
  Future<void> addNewMnemonic();
  Future<String> getStoredMnemonic();
}

@riverpod
MnemonicService mainMnemonicService(MainMnemonicServiceRef ref) {
  final mnemonicRepository =
      ref.watch(secureStorageMnemonicCipherRepositoryProvider);
  return MainMnemonicService(mnemonicRepository);
}

class MainMnemonicService implements MnemonicService {
  final MnemonicCipherRepository _mnemonicCipherRepository;

  MainMnemonicService(this._mnemonicCipherRepository);

  @override
  Future<void> addNewMnemonic() async {
    final mnemonic = await Mnemonic.create(WordCount.Words12);
    final ciphertext = '';
    await _mnemonicCipherRepository.setMnemonicCipher(ciphertext);
  }

  @override
  Future<String> getStoredMnemonic() async {
    final ciphertext = await _mnemonicCipherRepository.getMnemonicCipher();
    return '';
  }
}
