import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kumuly_pocket/enums/chat_message_status.dart';
import 'package:kumuly_pocket/enums/chat_message_type.dart';

@immutable
class ChatMessageEntity extends Equatable {
  const ChatMessageEntity({
    this.id,
    required this.contactId,
    required this.type,
    this.status,
    this.paymentHash,
    this.amountSat = 0,
    this.memo,
    this.isRead = false,
    required this.createdAt,
  });

  final int? id;
  final int contactId;
  final ChatMessageType type;
  final ChatMessageStatus? status;
  final String? paymentHash;
  final int amountSat;
  final String? memo;
  final bool isRead;
  final int createdAt; // Unix timestamp in seconds

  // Convert into a Map. The keys must correspond to the names of the
  // columns in the database. Without id since it's autoincremented.
  Map<String, dynamic> toMap() {
    return {
      'rowid': id,
      'contactId': contactId,
      'type': type.name,
      'status': status?.name,
      'paymentHash': paymentHash,
      'amountSat': amountSat,
      'memo': memo,
      'isRead': isRead ? 1 : 0,
      'createdAt': createdAt,
    };
  }

  // With id since it is used when retrieving from the database.
  factory ChatMessageEntity.fromMap(Map<String, dynamic> map) {
    return ChatMessageEntity(
      id: map['rowid'] as int,
      contactId: map['contactId'] as int,
      type: ChatMessageType.values.firstWhere(
        (element) => element.name == map['type'] as String,
      ),
      status: map['status'] == null
          ? null
          : ChatMessageStatus.values.firstWhere(
              (element) => element.name == map['status'] as String,
            ),
      paymentHash: map['paymentHash'] as String?,
      amountSat: map['amountSat'] as int,
      memo: map['memo'] as String?,
      isRead: map['isRead'] == 1,
      createdAt: map['createdAt'] as int,
    );
  }

  @override
  List<Object?> get props => [
        id,
        contactId,
        type,
        status,
        paymentHash,
        amountSat,
        memo,
        isRead,
        createdAt,
      ];
}
