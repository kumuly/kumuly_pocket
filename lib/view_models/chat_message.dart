import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:kumuly_pocket/entities/chat_message_entity.dart';
import 'package:kumuly_pocket/enums/chat_message_status.dart';
import 'package:kumuly_pocket/enums/chat_message_type.dart';

@immutable
class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.type,
    this.status,
    this.amountSat = 0,
    this.memo,
    this.isRead = false,
    required this.timestamp,
    this.showDateDivider = false,
  });

  final int id;
  final ChatMessageType type;
  // Todo: add the type of the destination: node id, lightning address, bolt12 of bicoin address..., this is needed to retry the payment
  final ChatMessageStatus? status;
  final int amountSat;
  final String? memo;
  final bool isRead;
  final int timestamp; // Unix timestamp in seconds
  final bool showDateDivider;

  factory ChatMessage.fromEntity(
    ChatMessageEntity entity, {
    bool showDateDivider = false,
  }) {
    return ChatMessage(
      id: entity.id!,
      type: entity.type,
      status: entity.status,
      amountSat: entity.amountSat,
      memo: entity.memo,
      isRead: entity.isRead,
      timestamp: entity.createdAt,
      showDateDivider: showDateDivider,
    );
  }

  String getDateTime(String today, String yesterday) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final DateTime now = DateTime.now();

    // Check if the date is today
    final bool isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final bool isYesterday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1;

    if (isToday) {
      // Return only the hour if it's today
      return today;
    } else if (isYesterday) {
      return yesterday;
    } else {
      // Return only the date if it's not today
      return DateFormat.yMd().format(date);
    }
  }

  String get hour {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat.Hm().format(date);
  }

  @override
  List<Object?> get props => [
        id,
        type,
        status,
        amountSat,
        memo,
        isRead,
        timestamp,
        showDateDivider,
      ];
}
