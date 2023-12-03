import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class PinState extends Equatable {
  final String pin;

  const PinState({
    this.pin = '',
  });

  PinState copyWith({
    String? pin,
  }) {
    return PinState(
      pin: pin ?? this.pin,
    );
  }

  @override
  List<Object> get props => [pin];
}
