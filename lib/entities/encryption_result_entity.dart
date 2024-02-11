import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class EncryptionResultEntity extends Equatable {
  const EncryptionResultEntity({
    required this.ciphertext,
    required this.iv,
    this.mac,
  });

  final String ciphertext;
  final String iv;
  final String? mac; // The MAC field in case of authenticated encryption

  EncryptionResultEntity.fromJson(Map<String, dynamic> json)
      : ciphertext = json['ciphertext'] as String,
        iv = json['iv'] as String,
        mac = json['mac'] as String?;

  Map<String, dynamic> toJson() => {
        'ciphertext': ciphertext,
        'iv': iv,
        'mac': mac,
      };

  @override
  List<Object?> get props => [
        ciphertext,
        iv,
        mac,
      ];
}
