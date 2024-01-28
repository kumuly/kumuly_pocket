import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cryptography_providers.g.dart';

@riverpod
String Function(String) hashFunction(HashFunctionRef ref) {
  return (String message) {
    final bytes = utf8.encode(message);
    final digest = sha256.convert(bytes);
    return digest.toString();
  };
}
