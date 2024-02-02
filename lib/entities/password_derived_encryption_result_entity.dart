import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/entities/encryption_result_entity.dart';

@immutable
class PasswordDerivedEncryptionResultEntity extends Equatable {
  const PasswordDerivedEncryptionResultEntity({
    required this.passwordSalt,
    required this.encryptionResultEntity,
  });

  final String
      passwordSalt; // The salt used to derive the encryption key from the password
  final EncryptionResultEntity encryptionResultEntity;

  PasswordDerivedEncryptionResultEntity.fromJson(Map<String, dynamic> json)
      : passwordSalt = json['passwordSalt'] as String,
        encryptionResultEntity = EncryptionResultEntity.fromJson(
            json['encryptionResultEntity'] as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {
        'passwordSalt': passwordSalt,
        'encryptionResultEntity': encryptionResultEntity.toJson(),
      };

  @override
  List<Object?> get props => [passwordSalt, encryptionResultEntity];
}
