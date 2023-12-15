// Todo: Move to pin feature folder and use the PinScreen for all insert pin screens
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
