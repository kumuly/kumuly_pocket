import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_storage_providers.g.dart';

@riverpod
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return const FlutterSecureStorage();
}

@riverpod
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  // Since the SharedPreferences constructor is not async,
  //  it is overridden in the main.dart file to make it synchronous.
  //  And here we don't need to do anything but declare the provider.
  throw UnimplementedError();
}
