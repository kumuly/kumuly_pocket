import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:kumuly_pocket/enums/mnemonic_length.dart';
import 'package:kumuly_pocket/repositories/encrypted_mnemonic_repository.dart';
import 'package:kumuly_pocket/services/pin_derived_encrypted_key_management_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mnemonic_service.g.dart';

abstract class MnemonicService {
  Future<String> createMnemonic(MnemonicLength length);
  Future<void> storeMnemonic(String mnemonic, String label, String pin);
  Future<String> getMnemonic(String label, String pin);
  Future<List<String>> getStoredMnemonics();
  Future<void> deleteMnemonic(String label, String pin);
}

class MasterKeyEncryptedMnemonicService implements MnemonicService {
  final EncryptedMnemonicRepository _encryptedMnemonicRepository;
  final PinDerivedEncryptedKeyManagementService _masterKeyManagementService;

  static const kDefaultMnemonicLabel = 'default';

  MasterKeyEncryptedMnemonicService(
    this._encryptedMnemonicRepository,
    this._masterKeyManagementService,
  );

  @override
  Future<String> createMnemonic(MnemonicLength length) async {
    final bdkWordCount = length == MnemonicLength.words12
        ? WordCount.Words12
        : WordCount.Words24;
    final mnemonic = await Mnemonic.create(bdkWordCount);
    return mnemonic.asString();
  }

  @override
  Future<void> storeMnemonic(String mnemonic, String label, String pin) async {
    final encryptedMnemonic = await _masterKeyManagementService.encrypt(
      mnemonic,
      pin,
    );
    await _encryptedMnemonicRepository.setEncryptedMnemonic(
      label,
      encryptedMnemonic,
    );
  }

  @override
  Future<String> getMnemonic(String label, String pin) async {
    final encryptedMnemonic =
        await _encryptedMnemonicRepository.getEncryptedMnemonic(label);

    return _masterKeyManagementService.decrypt(encryptedMnemonic, pin);
  }

  @override
  Future<List<String>> getStoredMnemonics() async {
    return _encryptedMnemonicRepository.getEncryptedMnemonicLabels();
  }

  @override
  Future<void> deleteMnemonic(String label, String pin) async {
    if (await _masterKeyManagementService.isPinValid(pin) == false) {
      throw UnauthorizedException('Invalid pin');
    }
    await _encryptedMnemonicRepository.deleteEncryptedMnemonic(label);
  }
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);
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
