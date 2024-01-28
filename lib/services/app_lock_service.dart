import 'package:kumuly_pocket/providers/cryptography_providers.dart';
import 'package:kumuly_pocket/repositories/pin_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_lock_service.g.dart';

@riverpod
AppLockService appLockService(AppLockServiceRef ref) {
  final pinRepository = ref.watch(secureStoragePinRepositoryProvider);
  final hashFunction = ref.watch(hashFunctionProvider);
  return AppLockServiceImpl(
    pinRepository,
    hashFunction,
  );
}

abstract class AppLockService {
  Future<void> createPin(String pin);
  Future<bool> hasPin();
  Future<bool> validatePin(String pin);
  Future<void> updatePin(String currentPin, String newPin);
  Future<void> addFailedAttempt(DateTime timestamp);
  Future<List<DateTime>> getFailedAttempts();
  Future<void> clearFailedAttempts();
}

class AppLockServiceImpl implements AppLockService {
  final PinRepository _pinRepository;
  final String Function(String) _hashFunction;

  static const kPinLength = 4;

  AppLockServiceImpl(
    this._pinRepository,
    this._hashFunction,
  );

  @override
  Future<void> createPin(String pin) async {
    if (pin.length != kPinLength) {
      throw const PinLengthException('PIN must be $kPinLength digits');
    }
    if (await _pinRepository.exists()) {
      // Use the change method to change the PIN or delete it first.
      throw const ExistingPinException('PIN already exists');
    }

    final digest = _hashFunction(pin);
    await _pinRepository.set(digest);
  }

  @override
  Future<bool> hasPin() {
    return _pinRepository.exists();
  }

  @override
  Future<void> updatePin(String currentPin, String newPin) async {
    if (newPin.length != kPinLength) {
      throw const PinLengthException('PIN must be $kPinLength digits');
    }

    if (!(await validatePin(currentPin))) {
      throw const IncorrectPinException('Current PIN is incorrect');
    }

    final digest = _hashFunction(newPin);
    await _pinRepository.set(digest);
  }

  @override
  Future<bool> validatePin(String pin) async {
    if (!(await hasPin())) {
      return false;
    }

    if (pin.length != kPinLength) {
      return false;
    }

    final existingDigest = await _pinRepository.get();
    final digest = _hashFunction(pin);

    return existingDigest == digest;
  }

  @override
  Future<void> addFailedAttempt(DateTime timestamp) {
    // TODO: implement addFailedAttempt
    throw UnimplementedError();
  }

  @override
  Future<List<DateTime>> getFailedAttempts() {
    // TODO: implement getFailedAttempts
    throw UnimplementedError();
  }

  @override
  Future<void> clearFailedAttempts() {
    // TODO: implement clearFailedAttempts
    throw UnimplementedError();
  }
}

class PinLengthException implements Exception {
  const PinLengthException(this.message);

  final String message;
}

class ExistingPinException implements Exception {
  const ExistingPinException(this.message);

  final String message;
}

class IncorrectPinException implements Exception {
  const IncorrectPinException(this.message);

  final String message;
}

/*
abstract class AppLockService {
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

@riverpod
Future<bool> checkPin(CheckPinRef ref, String pin) async {
  final walletService = ref.read(walletServiceImplProvider);
  return walletService.checkPin(pin);
}

@riverpod
AppLockService pinAppLockService(PinAppLockServiceRef ref) {
  final mnemonicRepository = ref.watch(secureStorageMnemonicRepositoryProvider);
  final pinRepository = ref.watch(secureStoragePinRepositoryProvider);
  return WalletServiceImpl(
    mnemonicRepository,
    pinRepository,
  );
}



class PinAppLockService implements AppLockService {
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
*/