import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/enums/mnemonic_language.dart';

@immutable
class SignUpState extends Equatable {
  final MnemonicLanguage language;
  final String alias;
  final String pin;
  final String pinConfirmation;
  final List<String> mnemonicWords;
  final String inviteCode;
  final String nodeId;
  final String workingDirPath;

  const SignUpState({
    this.language = MnemonicLanguage.english,
    this.alias = '',
    this.pin = '',
    this.pinConfirmation = '',
    this.mnemonicWords = const [],
    this.inviteCode = '',
    this.nodeId = '',
    this.workingDirPath = '',
  });

  SignUpState copyWith({
    MnemonicLanguage? language,
    String? alias,
    String? pin,
    String? pinConfirmation,
    List<String>? mnemonicWords,
    String? inviteCode,
    String? nodeId,
    String? workingDirPath,
  }) {
    return SignUpState(
      language: language ?? this.language,
      alias: alias ?? this.alias,
      pin: pin ?? this.pin,
      pinConfirmation: pinConfirmation ?? this.pinConfirmation,
      mnemonicWords: mnemonicWords ?? this.mnemonicWords,
      inviteCode: inviteCode ?? this.inviteCode,
      nodeId: nodeId ?? this.nodeId,
      workingDirPath: workingDirPath ?? this.workingDirPath,
    );
  }

  @override
  List<Object> get props => [
        language,
        alias,
        pin,
        pinConfirmation,
        mnemonicWords,
        inviteCode,
        nodeId,
        workingDirPath,
      ];
}
