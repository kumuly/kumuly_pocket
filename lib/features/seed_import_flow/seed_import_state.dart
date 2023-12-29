import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class SeedImportState extends Equatable {
  const SeedImportState({
    this.words = const [],
  });

  final List<String> words;

  SeedImportState copyWith({
    List<String>? words,
  }) {
    return SeedImportState(
      words: words ?? this.words,
    );
  }

  @override
  List<Object?> get props => [
        words,
      ];
}
