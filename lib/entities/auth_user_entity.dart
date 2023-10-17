import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthUserEntity extends Equatable {
  const AuthUserEntity({
    required this.id,
  });

  final String id;

  factory AuthUserEntity.fromFirebaseAuthUser(User user) {
    return AuthUserEntity(id: user.uid);
  }

  /// Empty user which represents an unauthenticated user.
  static const empty = AuthUserEntity(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == AuthUserEntity.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != AuthUserEntity.empty;

  @override
  List<Object?> get props => [id];
}
