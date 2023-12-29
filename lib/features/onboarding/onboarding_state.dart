import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/enums/mnemonic_language.dart';

@immutable
class OnboardingState extends Equatable {
  const OnboardingState({
    this.language = MnemonicLanguage.english,
    this.inviteCode = '',
    this.inviteCodeControllers = const [],
    this.inviteCodeFocusNodes = const [],
    this.pin = '',
    this.pinConfirmation = '',
    this.error,
  });

  final MnemonicLanguage language;
  final String inviteCode;
  final List<TextEditingController> inviteCodeControllers;
  final List<FocusNode> inviteCodeFocusNodes;
  final String pin;
  final String pinConfirmation;
  final Exception? error;

  OnboardingState copyWith({
    MnemonicLanguage? language,
    String? inviteCode,
    List<TextEditingController>? inviteCodeControllers,
    List<FocusNode>? inviteCodeFocusNodes,
    String? pin,
    String? pinConfirmation,
    Exception? error,
  }) {
    return OnboardingState(
      language: language ?? this.language,
      inviteCode: inviteCode ?? this.inviteCode,
      inviteCodeControllers:
          inviteCodeControllers ?? this.inviteCodeControllers,
      inviteCodeFocusNodes: inviteCodeFocusNodes ?? this.inviteCodeFocusNodes,
      pin: pin ?? this.pin,
      pinConfirmation: pinConfirmation ?? this.pinConfirmation,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        language,
        inviteCode,
        inviteCodeControllers,
        inviteCodeFocusNodes,
        pin,
        pinConfirmation,
        error,
      ];
}
