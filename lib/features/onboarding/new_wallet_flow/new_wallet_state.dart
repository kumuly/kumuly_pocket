import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/enums/mnemonic_language.dart';

@immutable
class NewWalletState extends Equatable {
  const NewWalletState({
    this.language = MnemonicLanguage.english,
    this.mnemonicWords = const [],
    this.inviteCode = '',
    this.inviteCodeControllers = const [],
    this.inviteCodeFocusNodes = const [],
    this.error,
  });

  final MnemonicLanguage language;
  final List<String> mnemonicWords;
  final String inviteCode;
  final List<TextEditingController> inviteCodeControllers;
  final List<FocusNode> inviteCodeFocusNodes;
  final Exception? error;

  NewWalletState copyWith({
    MnemonicLanguage? language,
    List<String>? mnemonicWords,
    String? inviteCode,
    List<TextEditingController>? inviteCodeControllers,
    List<FocusNode>? inviteCodeFocusNodes,
    Exception? error,
  }) {
    return NewWalletState(
      language: language ?? this.language,
      mnemonicWords: mnemonicWords ?? this.mnemonicWords,
      inviteCode: inviteCode ?? this.inviteCode,
      inviteCodeControllers:
          inviteCodeControllers ?? this.inviteCodeControllers,
      inviteCodeFocusNodes: inviteCodeFocusNodes ?? this.inviteCodeFocusNodes,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        language,
        mnemonicWords,
        inviteCode,
        inviteCodeControllers,
        inviteCodeFocusNodes,
        error,
      ];
}
