import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kumuly_pocket/entities/chat_message_entity.dart';
import 'package:kumuly_pocket/view_models/chat_message.dart';

@immutable
class ChatMessagesState extends Equatable {
  const ChatMessagesState({
    this.messageEntities = const [],
    this.messagesOffset = 0,
    required this.messagesLimit,
    this.hasMoreMessages = true,
  });

  final List<ChatMessageEntity> messageEntities;
  final int messagesOffset;
  final int messagesLimit;
  final bool hasMoreMessages;

  ChatMessagesState copyWith({
    List<ChatMessageEntity>? messageEntities,
    int? messagesOffset,
    int? messagesLimit,
    bool? hasMoreMessages,
  }) {
    return ChatMessagesState(
      messageEntities: messageEntities ?? this.messageEntities,
      messagesOffset: messagesOffset ?? this.messagesOffset,
      messagesLimit: messagesLimit ?? this.messagesLimit,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
    );
  }

  List<ChatMessage> get messages {
    String? latestDate;
    List<ChatMessage> viewModels = [];

    // The list needs to be reversed because the messages are sorted by createdAt DESC
    // and the list is scrolled to the bottom
    for (var entity in messageEntities.reversed) {
      print('messages entities: $entity');
      // Check if the date divider should be shown
      String currentDate = DateFormat.yMd()
          .format(DateTime.fromMillisecondsSinceEpoch(entity.createdAt * 1000));
      bool showDateDivider = latestDate != currentDate;
      if (showDateDivider) {
        latestDate = currentDate; // Update the latest date
      }

      // Create a new ChatMessage with the appropriate showDateDivider flag
      ChatMessage viewModel = ChatMessage.fromEntity(
        entity,
        showDateDivider: showDateDivider,
      );
      viewModels.add(viewModel);
    }

    // Reverse the list again to show the messages in the correct order
    return viewModels.reversed.toList();
  }

  @override
  List<Object?> get props => [
        messageEntities,
        messagesOffset,
        messagesLimit,
        hasMoreMessages,
      ];
}
