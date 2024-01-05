import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class PinSetupState extends Equatable {
  const PinSetupState({
    this.pin = '',
    this.pinConfirmation = '',
    this.error,
  });

  final String pin;
  final String pinConfirmation;
  final Exception? error;

  PinSetupState copyWith({
    String? pin,
    String? pinConfirmation,
    Exception? error,
  }) {
    return PinSetupState(
      pin: pin ?? this.pin,
      pinConfirmation: pinConfirmation ?? this.pinConfirmation,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        pin,
        pinConfirmation,
        error,
      ];
}
