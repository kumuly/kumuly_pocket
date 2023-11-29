import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/view_models/chat_message.dart';

@immutable
class ChatMessagesState extends Equatable {
  const ChatMessagesState({
    this.messages = const [],
    this.messagesOffset = 0,
    required this.messagesLimit,
    this.hasMoreMessages = true,
  });

  final List<ChatMessage> messages;
  final int messagesOffset;
  final int messagesLimit;
  final bool hasMoreMessages;

  ChatMessagesState copyWith({
    List<ChatMessage>? messages,
    int? messagesOffset,
    int? messagesLimit,
    bool? hasMoreMessages,
  }) {
    return ChatMessagesState(
      messages: messages ?? this.messages,
      messagesOffset: messagesOffset ?? this.messagesOffset,
      messagesLimit: messagesLimit ?? this.messagesLimit,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
    );
  }

  @override
  List<Object?> get props => [
        messages,
        messagesOffset,
        messagesLimit,
        hasMoreMessages,
      ];
}
