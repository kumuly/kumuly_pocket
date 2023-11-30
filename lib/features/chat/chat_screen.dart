import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/chat/chat_controller.dart';
import 'package:kumuly_pocket/features/chat/messages/chat_messages_controller.dart';
import 'package:kumuly_pocket/features/chat/send/chat_send_bottom_sheet_modal.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/backgrounds/background_container.dart';
import 'package:kumuly_pocket/widgets/buttons/expandable_fab.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/lists/chat_messages_list.dart';
import 'package:kumuly_pocket/widgets/shadows/bottom_shadow.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends ConsumerState<ChatScreen> {
  bool isModalOpen = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final chatState = ref.watch(chatControllerProvider(widget.id));

    final messagesState = ref
        .watch(chatMessagesControllerProvider(widget.id, kChatMessagesLimit));
    final messagesNotifier = ref.read(
        chatMessagesControllerProvider(widget.id, kChatMessagesLimit).notifier);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 88,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
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
              chatState.asData?.value.contactName ?? '',
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
            onPressed: () {
              // Todo: Show contact details to edit
            },
            icon: Icon(
              Icons.more_vert,
              color: Palette.neutral[70],
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          BackgroundContainer(
            appBarHeight: 0,
            assetName: 'assets/backgrounds/chat_background.png',
            color: Palette.neutral[20],
            child: ChatMessagesList(
              limit: kChatMessagesLimit,
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
          if (isModalOpen)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: Palette.neutral[40]!.withOpacity(0.2),
              ),
            ),
          /*BottomShadow(
            width: MediaQuery.of(context).size.width,
            spreadRadius: kSpacing12,
          ),*/
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 72,
        children: [
          ActionButton(
            onPressed: () {
              showModalBottomSheet(
                elevation: 0,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Palette.neutral[40]!, width: 1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                context: context,
                builder: (context) {
                  return ChatSendBottomSheetModal(contactId: widget.id);
                },
              ).whenComplete(() {
                // This is called when the modal is dismissed
                setState(() {
                  isModalOpen = false;
                });
              });

              // Set state to true when opening the modal
              setState(() {
                isModalOpen = true;
              });
            },
            icon: const DynamicIcon(
              icon: 'assets/icons/send_coins.svg',
              color: Colors.white,
              size: 24,
            ),
          ),
          ActionButton(
            onPressed: () {},
            icon: const DynamicIcon(
              icon: 'assets/icons/request_coins.svg',
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
