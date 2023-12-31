import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/enums/mnemonic_language.dart';

@immutable
class WalletRecoveryState extends Equatable {
  const WalletRecoveryState({
    this.language = MnemonicLanguage.english,
    required this.words,
  });

  final MnemonicLanguage language;
  final List<String> words;

  WalletRecoveryState copyWith({
    MnemonicLanguage? language,
    List<String>? words,
  }) {
    return WalletRecoveryState(
      language: language ?? this.language,
      words: words ?? this.words,
    );
  }

  bool get isValidSeed => words.every((word) => word.isNotEmpty);

  @override
  List<Object?> get props => [
        language,
        words,
      ];
}
