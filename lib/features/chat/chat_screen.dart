import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/features/chat/chat_controller.dart';
import 'package:kumuly_pocket/features/chat/chat_messages_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/backgrounds/background_container.dart';
import 'package:kumuly_pocket/widgets/lists/chat_messages_list.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final chatState = ref.watch(chatControllerProvider(id));
    const messagesLimit = 20;
    final messagesState =
        ref.watch(chatMessagesControllerProvider(id, messagesLimit));
    final messagesNotifier =
        ref.read(chatMessagesControllerProvider(id, messagesLimit).notifier);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 88,
        backgroundColor: Colors.white,
        title: Row(children: [
          CircleAvatar(
            backgroundColor: Palette.neutral[30],
            radius: 20,
            child: const Icon(
              Icons.person,
              color: Colors.black,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              chatState.asData?.value.contactName ?? id,
              style: textTheme.display3(
                Palette.neutral[100],
                FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]),
        titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              color: Palette.neutral[70],
            ),
          ),
        ],
      ),
      body: BackgroundContainer(
        appBarHeight: 0,
        assetName: 'assets/backgrounds/chat_background.png',
        color: Palette.neutral[20],
        child: ChatMessagesList(
          limit: messagesLimit,
          chatMessages: messagesState.hasValue
              ? messagesState.asData!.value.messages
              : [],
          loadChatMessages: messagesNotifier.fetchMessages,
          hasMore: messagesState.hasValue
              ? messagesState.asData!.value.hasMoreMessages
              : true,
          isLoading: messagesState.isLoading,
          isLoadingError: messagesState.hasError,
        ),
      ),
    );
  }
}
