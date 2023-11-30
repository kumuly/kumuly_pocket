import 'package:intl/intl.dart';
import 'package:kumuly_pocket/entities/chat_message_entity.dart';
import 'package:kumuly_pocket/features/chat/messages/chat_messages_state.dart';
import 'package:kumuly_pocket/services/chat_service.dart';
import 'package:kumuly_pocket/view_models/chat_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_messages_controller.g.dart';

@riverpod
class ChatMessagesController extends _$ChatMessagesController {
  @override
  FutureOr<ChatMessagesState> build(int contactId, int messagesLimit) async {
    final messages =
        await ref.read(sqliteChatServiceProvider).getMessagesByContactId(
              contactId,
              limit: messagesLimit,
            );

    return ChatMessagesState(
      messagesLimit: messagesLimit,
      messages: entityToViewModel(messages),
      messagesOffset: messages.length,
      hasMoreMessages: messages.length == messagesLimit,
    );
  }

  Future<void> fetchMessages({bool refresh = false}) async {
    await update((state) async {
      // Fetch messages
      final messages =
          await ref.read(sqliteChatServiceProvider).getMessagesByContactId(
                contactId,
                limit: state.messagesLimit,
                offset: refresh ? null : state.messagesOffset,
              );

      // Update state
      return state.copyWith(
        messages: refresh
            ? entityToViewModel(messages)
            : [
                ...state.messages,
                ...entityToViewModel(messages),
              ],
        messagesOffset: state.messagesOffset + messages.length,
        hasMoreMessages: messages.length == state.messagesLimit,
      );
    });
  }

  List<ChatMessage> entityToViewModel(List<ChatMessageEntity> entities) {
    String? latestDate;
    List<ChatMessage> viewModels = [];

    for (var entity in entities) {
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

    return viewModels;
  }
}
