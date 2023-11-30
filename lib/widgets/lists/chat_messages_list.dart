import 'package:flutter/material.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/chat_message_type.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/chat_message.dart';
import 'package:kumuly_pocket/widgets/lists/lazy_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatMessagesList extends StatelessWidget {
  const ChatMessagesList({
    super.key,
    required this.chatMessages,
    required this.loadChatMessages,
    required this.limit,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingError = false,
  });

  final List<ChatMessage> chatMessages;
  final Future<void> Function({bool refresh}) loadChatMessages;
  final int limit;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LazyList(
          reverse: true,
          items: chatMessages.map((chatMessage) {
            switch (chatMessage.type) {
              case ChatMessageType.newContact:
                return NewContactItem(
                  chatMessage,
                  key: Key(
                    chatMessage.id.toString(),
                  ),
                );
              case ChatMessageType.fundsSent:
                return FundsSentItem(
                  chatMessage,
                  key: Key(
                    chatMessage.id.toString(),
                  ),
                );
              default:
                return Container();
            }
          }).toList(),
          loadItems: loadChatMessages,
          limit: limit,
          hasMore: hasMore,
          isLoading: isLoading,
          isLoadingError: isLoadingError,
          emptyIndicator: null, // TODO: implement emptyIndicator
          errorIndicator: null, // TODO: implement errorIndicator
          noMoreItemsIndicator: null, // TODO: implement noMoreItemsIndicator
        ),
      ],
    );
  }
}

class DateDivider extends StatelessWidget {
  const DateDivider(this.date, {super.key});

  final String date;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: Palette.neutral[20],
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kSpacing3,
          vertical: kSpacing1,
        ),
        child: Text(
          date.toUpperCase(),
          style: textTheme.caption1(
            Palette.neutral[70],
            FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class NewContactItem extends StatelessWidget {
  const NewContactItem(
    this.chatMessage, {
    required super.key,
  });

  final ChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(
        top: kSpacing4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (chatMessage.showDateDivider)
            DateDivider(
              chatMessage.getDateTime(copy.today, copy.yesterday),
            ),
          Container(
            color: Palette.neutral[20],
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kSpacing3,
                vertical: kSpacing1,
              ),
              child: Text(
                copy.newContactAdded,
                style: textTheme.display1(
                  Palette.neutral[60],
                  FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FundsSentItem extends StatelessWidget {
  const FundsSentItem(this.message, {required super.key});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;

    return ListTile(
      horizontalTitleGap: 12,
      minVerticalPadding: kSpacing2 * 1.5,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      leading: CircleAvatar(
        backgroundColor: Palette.neutral[30],
        radius: 18,
        child: const Icon(
          Icons.person,
          color: Colors.black,
          size: 16,
        ),
      ),
      title: Text(
        copy.fundsSentSuccessfully,
        style: textTheme.display2(
          Palette.neutral[80],
          FontWeight.w400,
        ),
      ),
    );
  }
}
