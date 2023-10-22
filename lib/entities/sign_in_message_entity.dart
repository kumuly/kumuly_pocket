import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class SignInMessageEntity extends Equatable {
  final String id;
  final String message;
  final int expiryTimestamp;

  const SignInMessageEntity({
    required this.id,
    required this.message,
    required this.expiryTimestamp,
  });

  factory SignInMessageEntity.fromMap(Map<String, dynamic> map) {
    return SignInMessageEntity(
      id: map['id'] as String,
      message: map['message'] as String,
      expiryTimestamp: map['expiryTimestamp'] as int,
    );
  }

  @override
  List<Object?> get props => [id, message, expiryTimestamp];
}
