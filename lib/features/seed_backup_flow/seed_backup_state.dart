import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class SeedBackupState extends Equatable {
  const SeedBackupState({
    this.words = const [],
  });

  final List<String> words;

  SeedBackupState copyWith({
    List<String>? words,
  }) {
    return SeedBackupState(
      words: words ?? this.words,
    );
  }

  @override
  List<Object?> get props => [
        words,
      ];
}
