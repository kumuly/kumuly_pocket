import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class RecommendedFeesEntity extends Equatable {
  const RecommendedFeesEntity({
    required this.fastest,
    required this.fast,
    required this.medium,
    required this.slow,
    required this.cheapest,
  });

  final int fastest;
  final int fast;
  final int medium;
  final int slow;
  final int cheapest;

  @override
  List<Object> get props => [
        fastest,
        fast,
        medium,
        slow,
        cheapest,
      ];
}
