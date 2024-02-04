import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/entities/encryption_result_entity.dart';

@immutable
class PinDerivedEncryptionResultEntity extends Equatable {
  const PinDerivedEncryptionResultEntity({
    required this.pinSalt,
    required this.encryptionResult,
  });

  final String
      pinSalt; // The salt used to derive the encryption key from the pin
  final EncryptionResultEntity encryptionResult;

  PinDerivedEncryptionResultEntity.fromJson(Map<String, dynamic> json)
      : pinSalt = json['pinSalt'] as String,
        encryptionResult = EncryptionResultEntity.fromJson(
            json['encryptionResult'] as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {
        'pinSalt': pinSalt,
        'encryptionResult': encryptionResult.toJson(),
      };

  @override
  List<Object?> get props => [pinSalt, encryptionResult];
}
