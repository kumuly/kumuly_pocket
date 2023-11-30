import 'package:kumuly_pocket/features/chat/chat_controller.dart';
import 'package:kumuly_pocket/features/chat/messages/chat_messages_state.dart';
import 'package:kumuly_pocket/services/chat_service.dart';
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
      messageEntities: messages,
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
        messageEntities: refresh
            ? messages
            : [
                ...state.messageEntities,
                ...messages,
              ],
        messagesOffset: state.messagesOffset + messages.length,
        hasMoreMessages: messages.length == state.messagesLimit,
      );
    });
  }
}
