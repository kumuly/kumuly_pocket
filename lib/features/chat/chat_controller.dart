import 'package:kumuly_pocket/features/chat/chat_state.dart';
import 'package:kumuly_pocket/services/chat_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_controller.g.dart';

@riverpod
class ChatController extends _$ChatController {
  @override
  FutureOr<ChatState> build(int contactId) async {
    final contact =
        await ref.read(sqliteChatServiceProvider).getContactById(contactId);

    return ChatState(
      contactAvatarImagePath: contact?.avatarImagePath,
      contactName: contact?.name ?? '',
    );
  }
}
