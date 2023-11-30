import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:kumuly_pocket/enums/chat_message_status.dart';
import 'package:kumuly_pocket/enums/chat_message_type.dart';

@immutable
class ContactListItem extends Equatable {
  const ContactListItem({
    required this.contactId,
    required this.contactName,
    this.contactImagePath,
    this.description,
    required this.timestamp,
    required this.messageType,
    this.messageStatus,
    this.hasUnreadMessage = false,
  });

  final int contactId;
  final String contactName;
  final String? contactImagePath;
  final String? description;
  final int timestamp;
  final ChatMessageType messageType;
  final ChatMessageStatus? messageStatus;
  final bool hasUnreadMessage;

  String get dateTime {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final DateTime now = DateTime.now();

    // Check if the date is today
    final bool isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    if (isToday) {
      // Return only the hour if it's today
      return DateFormat.jm().format(date);
    } else {
      // Return only the date if it's not today
      return DateFormat.yMd().format(date);
    }
  }

  @override
  List<Object?> get props => [
        contactId,
        contactName,
        contactImagePath,
        description,
        timestamp,
        messageType,
        messageStatus,
        hasUnreadMessage,
      ];
}
