import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/view_models/account.dart';

@immutable
class SignInState extends Equatable {
  final List<Account> accounts;
  final Account selectedAccount;
  final String pin;

  const SignInState({
    this.accounts = const [],
    this.selectedAccount = Account.empty,
    this.pin = '',
  });

  SignInState copyWith({
    List<Account>? accounts,
    Account? selectedAccount,
    String? pin,
  }) {
    return SignInState(
      accounts: accounts ?? this.accounts,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      pin: pin ?? this.pin,
    );
  }

  @override
  List<Object> get props => [accounts, selectedAccount, pin];
}
