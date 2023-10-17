import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class AccountEntity extends Equatable {
  const AccountEntity({
    required this.nodeId,
    required this.alias,
    this.lastLogin,
    required this.workingDirPath,
  });

  final String nodeId;
  final String alias;
  final DateTime? lastLogin;
  final String workingDirPath;

  /// Empty user which represents no account.
  static const empty = AccountEntity(nodeId: '', alias: '', workingDirPath: '');

  /// Convenience getter to determine whether the current account is empty.
  bool get isEmpty => this == AccountEntity.empty;

  /// Convenience getter to determine whether the current account is not empty.
  bool get isNotEmpty => this != AccountEntity.empty;

  AccountEntity copyWith({
    String? nodeId,
    String? alias,
    DateTime? lastLogin,
    String? workingDirPath,
  }) {
    return AccountEntity(
      nodeId: nodeId ?? this.nodeId,
      alias: alias ?? this.alias,
      lastLogin: lastLogin ?? this.lastLogin,
      workingDirPath: workingDirPath ?? this.workingDirPath,
    );
  }

  @override
  List<Object?> get props => [nodeId, alias, lastLogin, workingDirPath];

  // Convert the AccountEntity instance into a Map.
  Map<String, dynamic> toJson() {
    return {
      'nodeId': nodeId,
      'alias': alias,
      'lastLogin': lastLogin?.toIso8601String(),
      'workingDirPath': workingDirPath,
    };
  }

  // Convert a Map into a AccountEntity instance.
  factory AccountEntity.fromJson(Map<String, dynamic> json) {
    return AccountEntity(
      nodeId: json['nodeId'] as String,
      alias: json['alias'] as String,
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(
              json['lastLogin'] as String) // Convert String to DateTime
          : null,
      workingDirPath: json['workingDirPath'] as String,
    );
  }

  // Convert a List<AccountEntity> into a List<Map>.
  static List<Map<String, dynamic>> toMapList(List<AccountEntity> users) {
    return users.map((user) => user.toJson()).toList();
  }

  // Convert a List<Map> into a List<AccountEntity>.
  static List<AccountEntity> fromMapList(List<dynamic> list) {
    return list.map((item) => AccountEntity.fromJson(item)).toList();
  }
}
