import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/enums/mnemonic_language.dart';
import 'package:kumuly_pocket/entities/account_entity.dart';
import 'package:kumuly_pocket/repositories/mnemonic_repository.dart';
import 'package:kumuly_pocket/repositories/account_repository.dart';
import 'package:kumuly_pocket/repositories/pin_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_service.g.dart';

@riverpod
AccountService sharedPreferencesAccountService(
    SharedPreferencesAccountServiceRef ref) {
  final accountRepository =
      ref.watch(sharedPreferencesAccountRepositoryProvider);
  final mnemonicRepository = ref.watch(secureStorageMnemonicRepositoryProvider);
  final pinRepository = ref.watch(secureStoragePinRepositoryProvider);
  return SharedPreferencesAccountsService(
    accountRepository,
    mnemonicRepository,
    pinRepository,
  );
}

@riverpod
List<AccountEntity> accounts(AccountsRef ref) {
  final accountService = ref.watch(sharedPreferencesAccountServiceProvider);
  final accountsStateChanged = ref.watch(accountsStateChangedProvider);
  if (accountsStateChanged.isLoading || accountsStateChanged.hasError) {
    return accountService.accounts;
  }
  return accountsStateChanged.asData?.value ?? accountService.accounts;
}

@riverpod
Stream<List<AccountEntity>> accountsStateChanged(AccountsStateChangedRef ref) {
  final accountService = ref.watch(sharedPreferencesAccountServiceProvider);
  return accountService.accountsStateChanged;
}

@riverpod
Future<bool> checkPin(CheckPinRef ref, String nodeId, String pin) {
  final accountService = ref.watch(sharedPreferencesAccountServiceProvider);
  return accountService.checkPin(nodeId, pin);
}

abstract class AccountService {
  List<AccountEntity> get accounts;
  Stream<List<AccountEntity>> get accountsStateChanged;
  Future<List<String>> generateAccountWallet(MnemonicLanguage language);
  Future<void> addAccount(
    AccountEntity account,
    List<String> mnemonicWords,
    String pin,
  );
  Future<AccountEntity> getAccount(String nodeId);
  Future<void> deleteAccount(AccountEntity account, String pin);
  Future<bool> checkPin(String nodeId, String pin);
  void dispose();
}

class SharedPreferencesAccountsService implements AccountService {
  SharedPreferencesAccountsService(
    this._accountRepository,
    this._mnemonicRepository,
    this._pinRepository,
  );

  final AccountRepository _accountRepository;
  final MnemonicRepository _mnemonicRepository;
  final PinRepository _pinRepository;

  @override
  List<AccountEntity> get accounts => _accountRepository.accounts;

  @override
  Stream<List<AccountEntity>> get accountsStateChanged =>
      _accountRepository.accountsStateChanged;

  @override
  Future<List<String>> generateAccountWallet(MnemonicLanguage language) async {
    final mnemonicWords = await _mnemonicRepository.newMnemonicWords(
      language,
    );
    return mnemonicWords;
  }

  @override
  Future<void> addAccount(
    AccountEntity account,
    List<String> mnemonicWords,
    String pin,
  ) async {
    // Store the mnemonic of the account in secure storage by the nodeId.
    await _mnemonicRepository.saveWords(
      account.nodeId,
      mnemonicWords,
    );
    print(
      'Mnemonic saved for node id ${account.nodeId} with alias: ${account.alias}',
    );

    // Store the pin of the account in secure storage by the nodeId.
    await _pinRepository.save(account.nodeId, pin);

    // Store the account in shared preferences.
    await _accountRepository.save(account);
  }

  @override
  Future<AccountEntity> getAccount(String nodeId) async {
    return _accountRepository.get(nodeId);
  }

  @override
  Future<void> deleteAccount(AccountEntity account, String pin) async {
    // Delete the working directory of the node of the account.
    final dir = Directory(account.workingDirPath);
    await dir.delete(recursive: true);

    // Delete the account from shared preferences.
    await _accountRepository.delete(account);

    // Delete the pin of the account from secure storage.
    await _pinRepository.delete(account.nodeId, pin);

    // Delete the mnemonic of the account from secure storage.
    await _mnemonicRepository.deleteWords(account.nodeId);
  }

  @override
  Future<bool> checkPin(String nodeId, String pin) async {
    return _pinRepository.validate(nodeId, pin);
  }

  @override
  void dispose() {
    _accountRepository.dispose();
  }
}
