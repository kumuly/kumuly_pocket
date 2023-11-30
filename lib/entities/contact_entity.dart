import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ContactEntity extends Equatable {
  const ContactEntity({
    this.id,
    required this.name,
    this.avatarImagePath,
    this.nodeId,
    this.bolt12,
    this.lightningAddress,
    this.bitcoinAddress,
    required this.createdAt,
  });

  final int? id;
  final String name;
  final String? avatarImagePath;
  final String? nodeId;
  final String? bolt12;
  final String? lightningAddress;
  final String? bitcoinAddress;
  final int createdAt;

  // Convert into a Map. The keys must correspond to the names of the
  // columns in the database. Without id since it's autoincremented.
  Map<String, dynamic> toMap() {
    return {
      'rowid': id,
      'name': name,
      'avatarImagePath': avatarImagePath,
      'nodeId': nodeId,
      'bolt12': bolt12,
      'lightningAddress': lightningAddress,
      'bitcoinAddress': bitcoinAddress,
      'createdAt': createdAt,
    };
  }

  // With id since it is used when retrieving from the database.
  factory ContactEntity.fromMap(Map<String, dynamic> map) {
    print('Contact entity from map: $map');
    return ContactEntity(
      id: map['rowid'] as int,
      name: map['name'] as String,
      avatarImagePath: map['avatarImagePath'] as String?,
      nodeId: map['nodeId'] as String?,
      bolt12: map['bolt12'] as String?,
      lightningAddress: map['lightningAddress'] as String?,
      bitcoinAddress: map['bitcoinAddress'] as String?,
      createdAt: map['createdAt'] as int,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        avatarImagePath,
        nodeId,
        bolt12,
        lightningAddress,
        bitcoinAddress,
        createdAt,
      ];
}
