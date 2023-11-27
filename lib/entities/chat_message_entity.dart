import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/enums/chat_message_type.dart';

@immutable
class ChatMessageEntity extends Equatable {
  const ChatMessageEntity({
    required this.id,
    required this.contactId,
    required this.type,
    this.amountSat = 0,
    this.isRead = false,
    required this.createdAt,
  });

  final String id;
  final String contactId;
  final ChatMessageType type;
  final int amountSat;
  final bool isRead;
  final int createdAt; // Unix timestamp in seconds

  // Convert into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contactId': contactId,
      'type': type.name,
      'amountSat': amountSat,
      'isRead': isRead ? 1 : 0,
      'createdAt': createdAt,
    };
  }

  factory ChatMessageEntity.fromMap(Map<String, dynamic> map) {
    return ChatMessageEntity(
      id: map['id'] as String,
      contactId: map['contactId'] as String,
      type: ChatMessageType.values.firstWhere(
        (element) => element.name == map['type'] as String,
      ),
      amountSat: map['amountSat'] as int,
      isRead: map['isRead'] == 1,
      createdAt: map['createdAt'] as int,
    );
  }

  @override
  List<Object?> get props => [
        id,
        contactId,
        type,
        amountSat,
        isRead,
        createdAt,
      ];
}
