import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ContactEntity extends Equatable {
  const ContactEntity({
    required this.id,
    required this.name,
    this.avatarImagePath,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String? avatarImagePath;
  final int createdAt;

  // Convert into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatarImagePath': avatarImagePath,
      'createdAt': createdAt,
    };
  }

  factory ContactEntity.fromMap(Map<String, dynamic> map) {
    return ContactEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      avatarImagePath: map['avatarImagePath'] as String?,
      createdAt: map['createdAt'] as int,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        avatarImagePath,
        createdAt,
      ];
}
