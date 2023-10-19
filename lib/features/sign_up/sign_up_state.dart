import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/enums/mnemonic_language.dart';

@immutable
class SignUpState extends Equatable {
  final MnemonicLanguage language;
  final String alias;
  final String pin;
  final String pinConfirmation;

  const SignUpState({
    this.language = MnemonicLanguage.english,
    this.alias = '',
    this.pin = '',
    this.pinConfirmation = '',
  });

  SignUpState copyWith({
    MnemonicLanguage? language,
    String? alias,
    String? pin,
    String? pinConfirmation,
  }) {
    return SignUpState(
      language: language ?? this.language,
      alias: alias ?? this.alias,
      pin: pin ?? this.pin,
      pinConfirmation: pinConfirmation ?? this.pinConfirmation,
    );
  }

  @override
  List<Object> get props => [language, alias, pin, pinConfirmation];
}
