import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/enums/mnemonic_length.dart';

@immutable
class OnboardingState extends Equatable {
  const OnboardingState({
    required this.inviteCodeLength,
    this.inviteCode = '',
    this.inviteCodeControllers = const [],
    this.inviteCodeFocusNodes = const [],
    required this.mnemonicLength,
    this.recoveredWords = const [],
    this.mnemonic = '',
    this.pin = '',
    this.pinConfirmation = '',
    this.error,
  });

  final int inviteCodeLength;
  final String inviteCode;
  final List<TextEditingController> inviteCodeControllers;
  final List<FocusNode> inviteCodeFocusNodes;
  final MnemonicLength mnemonicLength;
  final List<String> recoveredWords;
  final String mnemonic;
  final String pin;
  final String pinConfirmation;
  final Exception? error;

  OnboardingState copyWith({
    int? inviteCodeLength,
    String? inviteCode,
    List<TextEditingController>? inviteCodeControllers,
    List<FocusNode>? inviteCodeFocusNodes,
    MnemonicLength? mnemonicLength,
    List<String>? recoveredWords,
    String? mnemonic,
    String? pin,
    String? pinConfirmation,
    Exception? error,
  }) {
    return OnboardingState(
      inviteCodeLength: inviteCodeLength ?? this.inviteCodeLength,
      inviteCode: inviteCode ?? this.inviteCode,
      inviteCodeControllers:
          inviteCodeControllers ?? this.inviteCodeControllers,
      inviteCodeFocusNodes: inviteCodeFocusNodes ?? this.inviteCodeFocusNodes,
      mnemonicLength: mnemonicLength ?? this.mnemonicLength,
      recoveredWords: recoveredWords ?? this.recoveredWords,
      mnemonic: mnemonic ?? this.mnemonic,
      pin: pin ?? this.pin,
      pinConfirmation: pinConfirmation ?? this.pinConfirmation,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        inviteCodeLength,
        inviteCode,
        inviteCodeControllers,
        inviteCodeFocusNodes,
        mnemonicLength,
        recoveredWords,
        mnemonic,
        pin,
        pinConfirmation,
        error,
      ];
}
