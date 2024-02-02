import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:kumuly_pocket/repositories/encrypted_mnemonic_repository.dart';
import 'package:kumuly_pocket/services/password_derived_encrypted_key_management_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mnemonic_service.g.dart';

abstract class MnemonicService {
  Future<void> createMnemonic(String label, String password);
  Future<String> getMnemonic(String label, String password);
  Future<List<String>> getStoredMnemonics();
  Future<void> deleteMnemonic(String label, String password);
}

@riverpod
MnemonicService masterKeyEncryptedMnemonicService(
    MasterKeyEncryptedMnemonicServiceRef ref) {
  final encryptedMnemonicRepository = ref.watch(
    secureStorageEncryptedMnemonicRepositoryProvider,
  );
  final masterKeyManagementService = ref.watch(
    masterKeyManagementServiceProvider,
  );
  return MasterKeyEncryptedMnemonicService(
    encryptedMnemonicRepository,
    masterKeyManagementService,
  );
}

class MasterKeyEncryptedMnemonicService implements MnemonicService {
  final EncryptedMnemonicRepository _encryptedMnemonicRepository;
  final PasswordDerivedEncryptedKeyManagementService
      _masterKeyManagementService;

  MasterKeyEncryptedMnemonicService(
    this._encryptedMnemonicRepository,
    this._masterKeyManagementService,
  );

  @override
  Future<void> createMnemonic(String label, String password) async {
    final mnemonic = await Mnemonic.create(WordCount.Words12);
    final encryptedMnemonic = await _masterKeyManagementService.encrypt(
      mnemonic.asString(),
      password,
    );
    await _encryptedMnemonicRepository.setEncryptedMnemonic(
      label,
      encryptedMnemonic,
    );
  }

  @override
  Future<String> getMnemonic(String label, String password) async {
    final encryptedMnemonic =
        await _encryptedMnemonicRepository.getEncryptedMnemonic(label);

    return _masterKeyManagementService.decrypt(encryptedMnemonic, password);
  }

  @override
  Future<List<String>> getStoredMnemonics() async {
    return _encryptedMnemonicRepository.getEncryptedMnemonicLabels();
  }

  @override
  Future<void> deleteMnemonic(String label, String password) async {
    if (await _masterKeyManagementService.isPasswordValid(password) == false) {
      throw UnauthorizedException('Invalid password');
    }
    await _encryptedMnemonicRepository.deleteEncryptedMnemonic(label);
  }
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);
}
