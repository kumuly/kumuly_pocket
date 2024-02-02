import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/entities/encryption_result_entity.dart';

@immutable
class PasswordDerivedEncryptionResultEntity extends Equatable {
  const PasswordDerivedEncryptionResultEntity({
    required this.passwordSalt,
    required this.encryptionResult,
  });

  final String
      passwordSalt; // The salt used to derive the encryption key from the password
  final EncryptionResultEntity encryptionResult;

  PasswordDerivedEncryptionResultEntity.fromJson(Map<String, dynamic> json)
      : passwordSalt = json['passwordSalt'] as String,
        encryptionResult = EncryptionResultEntity.fromJson(
            json['encryptionResult'] as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {
        'passwordSalt': passwordSalt,
        'encryptionResult': encryptionResult.toJson(),
      };

  @override
  List<Object?> get props => [passwordSalt, encryptionResult];
}
