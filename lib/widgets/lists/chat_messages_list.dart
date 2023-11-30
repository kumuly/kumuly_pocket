import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/chat_message_status.dart';
import 'package:kumuly_pocket/enums/chat_message_type.dart';
import 'package:kumuly_pocket/enums/local_currency.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
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
    this.scrollController,
  });

  final List<ChatMessage> chatMessages;
  final Future<void> Function({bool refresh}) loadChatMessages;
  final int limit;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingError;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: LazyList(
            reverse: true,
            scrollController: scrollController,
            items: chatMessages
                .asMap()
                .map((index, chatMessage) => MapEntry(
                    index,
                    ChatMessageItem(
                      chatMessage,
                      key: Key(chatMessage.id.toString()),
                      isMostRecent: index == 0,
                    )))
                .values
                .toList(),
            loadItems: loadChatMessages,
            limit: limit,
            hasMore: hasMore,
            isLoading: isLoading,
            isLoadingError: isLoadingError,
            emptyIndicator: null, // TODO: implement emptyIndicator
            errorIndicator: null, // TODO: implement errorIndicator
            noMoreItemsIndicator: null, // TODO: implement noMoreItemsIndicator
          ),
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
        padding: const EdgeInsets.only(
          top: kSpacing4,
          left: kSpacing3,
          right: kSpacing3,
          bottom: kSpacing1,
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

class ChatMessageItem extends StatelessWidget {
  const ChatMessageItem(
    this.chatMessage, {
    this.isMostRecent = false,
    required super.key,
  });

  final ChatMessage chatMessage;
  final bool isMostRecent;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (chatMessage.showDateDivider)
          DateDivider(
            chatMessage.getDateTime(copy.today, copy.yesterday),
          ),
        switch (chatMessage.type) {
          ChatMessageType.newContact => NewContactContent(chatMessage),
          ChatMessageType.fundsSent => FundsSentContent(chatMessage),
          _ => Container(),
        },
        // Add spacing between the most recent message and the bottom of the list
        // to make sure the message is not hidden by the floating action button
        if (isMostRecent) const SizedBox(height: kSpacing11),
      ],
    );
  }
}

class NewContactContent extends StatelessWidget {
  const NewContactContent(
    this.chatMessage, {
    super.key,
  });

  final ChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;

    return Container(
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
    );
  }
}

class FundsSentContent extends ConsumerWidget {
  const FundsSentContent(this.chatMessage, {super.key});

  final ChatMessage chatMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;

    final amount =
        ref.watch(displayBitcoinAmountProvider(chatMessage.amountSat));
    final bitcoinUnit = ref.watch(bitcoinUnitProvider);
    final localCurrency = ref.watch(localCurrencyProvider);
    final localCurrencyAmount =
        ref.watch(satToLocalProvider(chatMessage.amountSat)).asData?.value ?? 0;

    return Padding(
      padding: const EdgeInsets.only(
        top: kSpacing1 * 1.5,
        right: kSpacing1 * 1.5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Card(
            color: Palette.neutral[30],
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(kSpacing3),
                bottomLeft: Radius.circular(kSpacing3),
                bottomRight: Radius.circular(kSpacing3),
              ),
            ),
            child: Container(
              width: 296,
              padding: const EdgeInsets.only(
                top: kSpacing1 * 1.5,
                right: kSpacing1 * 1.5,
                bottom: kSpacing2 * 1.25,
                left: kSpacing2 * 1.25,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      switch (chatMessage.status) {
                        ChatMessageStatus.sent => Text(
                            '${chatMessage.hour}・${copy.youSent}',
                            style: textTheme.display1(
                              Palette.neutral[60],
                              FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ChatMessageStatus.failed => Text(
                            copy.failed,
                            style: textTheme.display1(
                              Palette.error[100],
                              FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        _ => Container(),
                      },
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (chatMessage.memo != null &&
                          chatMessage.memo!.isNotEmpty)
                        Text(
                          chatMessage.memo!,
                          style: textTheme.display2(
                            Palette.neutral[80],
                            FontWeight.w400,
                          ),
                          textAlign: TextAlign.left,
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: kSpacing2 * 1.25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '- $amount ${bitcoinUnit.name.toUpperCase()}',
                                style: textTheme.display6(
                                  Palette.neutral[70],
                                  FontWeight.w600,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          Text(
                            '≈ ${localCurrencyAmount.toStringAsFixed(2)} ${localCurrency.symbol.toUpperCase()}',
                            style: textTheme.caption1(
                              Palette.neutral[70],
                              FontWeight.w400,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
