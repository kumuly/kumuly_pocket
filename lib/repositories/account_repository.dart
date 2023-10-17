import 'dart:async';
import 'dart:convert';
import 'package:kumuly_pocket/entities/account_entity.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'account_repository.g.dart';

@riverpod
AccountRepository sharedPreferencesAccountRepository(
    SharedPreferencesAccountRepositoryRef ref) {
  final sharedPreferences = ref.read(sharedPreferencesProvider);
  return SharedPreferencesAccountRepository(sharedPreferences);
}

abstract class AccountRepository {
  List<AccountEntity> get accounts;
  Stream<List<AccountEntity>> get accountsStateChanged;
  Future<String> save(AccountEntity account);
  AccountEntity get(String id);
  Future<void> delete(AccountEntity account);
  void dispose();
}

class SharedPreferencesAccountRepository implements AccountRepository {
  static const _accountKeyPrefix = 'account_';
  final _accountsStateChangedStreamController =
      StreamController<List<AccountEntity>>.broadcast();

  SharedPreferencesAccountRepository(
    this._sharedPreferences,
  );

  final SharedPreferences _sharedPreferences;

  @override
  List<AccountEntity> get accounts {
    return _accountIds.map((id) => get(id)).toList();
  }

  @override
  Stream<List<AccountEntity>> get accountsStateChanged {
    return _accountsStateChangedStreamController.stream;
  }

  @override
  Future<String> save(AccountEntity account) async {
    final key = '$_accountKeyPrefix${account.nodeId}';
    final isSaved = await _sharedPreferences.setString(
      key,
      _encode(account),
    );
    if (!isSaved) {
      throw Exception('Failed to save account');
    }
    _updateAccountsStateChangedStream();
    return account.nodeId;
  }

  @override
  AccountEntity get(String id) {
    final key = '$_accountKeyPrefix$id';
    final accountJsonString = _sharedPreferences.getString(key);
    if (accountJsonString == null) {
      throw Exception('Account not found');
    }
    return _decode(accountJsonString);
  }

  @override
  Future<void> delete(AccountEntity account) async {
    final key = '$_accountKeyPrefix${account.nodeId}';
    await _sharedPreferences.remove(key);
    _updateAccountsStateChangedStream();
  }

  @override
  void dispose() {
    _accountsStateChangedStreamController.close();
  }

  List<String> get _accountIds {
    return _sharedPreferences
        .getKeys()
        .where((key) => key.startsWith(_accountKeyPrefix))
        .map((key) => key.substring(_accountKeyPrefix.length))
        .toList();
  }

  void _updateAccountsStateChangedStream() {
    _accountsStateChangedStreamController.add(accounts);
  }

  String _encode(AccountEntity account) {
    return jsonEncode(account.toJson());
  }

  AccountEntity _decode(String accountJsonString) {
    final accountJson = jsonDecode(accountJsonString);
    final account = AccountEntity.fromJson(accountJson);
    return account;
  }
}
