import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pin_repository.g.dart';

@riverpod
PinRepository secureStoragePinRepository(SecureStoragePinRepositoryRef ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return SecureStoragePinRepository(secureStorage);
}

abstract class PinRepository {
  Future<void> set(String pin);
  Future<bool> hasPin();
  Future<bool> validate(String pin);
  Future<void> change(String pin, String newPin);
  Future<void> delete(String pin);
}

class SecureStoragePinRepository implements PinRepository {
  const SecureStoragePinRepository(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> set(String pin) async {
    if (pin.length != kPinLength) {
      throw Exception('PIN must be 4 digits');
    }

    // Check if the PIN is already set.
    if (await _secureStorage.containsKey(key: kPinDigestKey)) {
      // Use the change method to change the PIN or delete it first.
      throw Exception('PIN is already set');
    }

    // Store the pin digest in the secure storage.
    await _writePinDigest(pin);
  }

  @override
  Future<bool> hasPin() async {
    if (await _secureStorage.containsKey(key: kPinDigestKey) &&
        await _secureStorage.read(key: kPinDigestKey) != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> validate(String pin) async {
    if (!(await _secureStorage.containsKey(key: kPinDigestKey))) {
      return false;
    }

    if (pin.length != kPinLength) {
      return false;
    }

    final existingDigest = await _secureStorage.read(key: kPinDigestKey);
    final digest = _hashPin(pin);

    return existingDigest == digest;
  }

  @override
  Future<void> change(String pin, String newPin) async {
    if (newPin.length != kPinLength) {
      throw Exception('New PIN must be 4 digits');
    }

    if (!(await validate(pin))) {
      throw Exception('Current PIN does not match');
    }

    await _writePinDigest(newPin);
  }

  @override
  Future<void> delete(String pin) async {
    if (!(await validate(pin))) {
      throw Exception('PIN does not match');
    }

    await _secureStorage.delete(key: kPinDigestKey);
  }

  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _writePinDigest(String pin) async {
    final digest = _hashPin(pin);
    await _secureStorage.write(key: kPinDigestKey, value: digest);
  }
}
