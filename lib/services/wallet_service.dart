import 'package:kumuly_pocket/entities/mnemonic_entity.dart';
import 'package:kumuly_pocket/enums/mnemonic_language.dart';
import 'package:kumuly_pocket/repositories/mnemonic_repository.dart';
import 'package:kumuly_pocket/repositories/pin_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_service.g.dart';

@riverpod
Future<bool> checkPin(CheckPinRef ref, String pin) async {
  final walletService = ref.read(walletServiceImplProvider);
  return walletService.checkPin(pin);
}

@riverpod
WalletService walletServiceImpl(WalletServiceImplRef ref) {
  final mnemonicRepository = ref.watch(secureStorageMnemonicRepositoryProvider);
  final pinRepository = ref.watch(secureStoragePinRepositoryProvider);
  return WalletServiceImpl(
    mnemonicRepository,
    pinRepository,
  );
}

abstract class WalletService {
  Future<List<String>> generateWallet(
    MnemonicLanguage language,
  );
  Future<void> saveWallet(
    MnemonicEntity mnemonic,
  );
  Future<bool> hasWallet();
  Future<void> setPin(String pin);
  Future<bool> hasPin();
  Future<void> changePin(String currentPin, String newPin);
  Future<bool> checkPin(String pin);
}

class WalletServiceImpl implements WalletService {
  WalletServiceImpl(
    this._mnemonicRepository,
    this._pinRepository,
  );

  final MnemonicRepository _mnemonicRepository;
  final PinRepository _pinRepository;

  @override
  Future<List<String>> generateWallet(
    MnemonicLanguage language,
  ) async {
    return await _mnemonicRepository.generate(language);
  }

  @override
  Future<void> saveWallet(
    MnemonicEntity mnemonic,
  ) async {
    await _mnemonicRepository.set(mnemonic);
  }

  @override
  Future<bool> hasWallet() async {
    try {
      await _mnemonicRepository.getWords();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> setPin(
    String pin,
  ) async {
    await _pinRepository.set(pin);
  }

  @override
  Future<bool> hasPin() async {
    return await _pinRepository.hasPin();
  }

  @override
  Future<void> changePin(String currentPin, String newPin) async {
    await _pinRepository.change(currentPin, newPin);
  }

  @override
  Future<bool> checkPin(String pin) async {
    return _pinRepository.validate(pin);
  }
}
