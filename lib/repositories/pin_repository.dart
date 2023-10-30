import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pin_repository.g.dart';

@riverpod
PinRepository secureStoragePinRepository(SecureStoragePinRepositoryRef ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return SecureStoragePinRepository(secureStorage);
}

abstract class PinRepository {
  Future<void> save(String id, String pin);
  Future<bool> validate(String id, String pin);
  Future<void> change(String id, String pin, String newPin);
  Future<void> delete(String id, String pin);
}

class SecureStoragePinRepository implements PinRepository {
  const SecureStoragePinRepository(this._secureStorage);

  final FlutterSecureStorage _secureStorage;
  static const _pinDigestKeyPrefix = 'pinDigest_';
  static const _pinLength = 4;

  @override
  Future<void> save(String id, String pin) async {
    final key = '$_pinDigestKeyPrefix$id';

    if (pin.length != _pinLength) {
      throw Exception('PIN must be 4 digits');
    }

    // Store the pin digest in the secure storage.
    await _writePinDigest(key: key, pin: pin);
  }

  @override
  Future<bool> validate(String id, String pin) async {
    final key = '$_pinDigestKeyPrefix$id';
    if (!(await _secureStorage.containsKey(key: key))) {
      return false;
    }

    if (pin.length != _pinLength) {
      return false;
    }

    final existingDigest = await _secureStorage.read(key: key);
    final digest = _hashPin(pin);

    return existingDigest == digest;
  }

  @override
  Future<void> change(String id, String pin, String newPin) async {
    if (newPin.length != _pinLength) {
      throw Exception('New PIN must be 4 digits');
    }

    if (!(await validate(id, pin))) {
      throw Exception('Current PIN does not match');
    }

    final key = '$_pinDigestKeyPrefix$id';
    await _writePinDigest(key: key, pin: newPin);
  }

  @override
  Future<void> delete(String id, String pin) async {
    if (!(await validate(id, pin))) {
      throw Exception('PIN does not match');
    }

    final key = '$_pinDigestKeyPrefix$id';
    await _secureStorage.delete(key: key);
  }

  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _writePinDigest(
      {required String key, required String pin}) async {
    final digest = _hashPin(pin);
    await _secureStorage.write(key: key, value: digest);
  }
}
