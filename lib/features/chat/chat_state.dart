import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ChatState extends Equatable {
  const ChatState({
    this.contactAvatarImagePath,
    required this.contactName,
  });

  final String? contactAvatarImagePath;
  final String contactName;

  ChatState copyWith({
    String? contactAvatarImagePath,
    String? contactName,
  }) {
    return ChatState(
      contactAvatarImagePath:
          contactAvatarImagePath ?? this.contactAvatarImagePath,
      contactName: contactName ?? this.contactName,
    );
  }

  @override
  List<Object?> get props => [
        contactAvatarImagePath,
        contactName,
      ];
}
