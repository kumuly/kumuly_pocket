import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/chat_message_status.dart';
import 'package:kumuly_pocket/enums/chat_message_type.dart';
import 'package:kumuly_pocket/router/app_router.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/contact_list_item.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/lists/lazy_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({
    super.key,
    required this.contactListItems,
    required this.loadContactListItems,
    required this.limit,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingError = false,
  });

  final List<ContactListItem> contactListItems;
  final Future<void> Function({bool refresh}) loadContactListItems;
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
          neverScrollable: true,
          items: contactListItems
              .map(
                (contactListItem) => ContactListItemWidget(
                  contactListItem,
                  key: Key(
                    contactListItem.contactName,
                  ),
                ),
              )
              .toList(),
          loadItems: loadContactListItems,
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

class ContactListItemWidget extends ConsumerWidget {
  const ContactListItemWidget(this.contactListItem, {required super.key});

  final ContactListItem contactListItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);

    return ListTile(
      horizontalTitleGap: 12,
      minVerticalPadding: kSpacing2 * 1.5,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      leading: contactListItem.contactImagePath != null
          ? CircleAvatar(
              radius: 18,
              backgroundImage:
                  FileImage(File(contactListItem.contactImagePath!)),
            )
          : CircleAvatar(
              backgroundColor: Palette.neutral[20],
              radius: 18,
              child: const Icon(
                Icons.person,
                size: 12.5,
              ), // Default icon if no image is selected
            ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(contactListItem.contactName),
          switch (contactListItem.messageType) {
            ChatMessageType.fundsReceived => DynamicIcon(
                icon: 'assets/icons/receive_arrow.svg',
                color: Palette.success[50],
                size: 7.5,
              ),
            ChatMessageType.fundsSent =>
              contactListItem.messageStatus != null &&
                      contactListItem.messageStatus == ChatMessageStatus.failed
                  ? Text(
                      copy.failed.toUpperCase(),
                      style: textTheme.caption1(
                        Palette.error[50],
                        FontWeight.w400,
                      ),
                    )
                  : DynamicIcon(
                      icon: 'assets/icons/send_arrow.svg',
                      color: Palette.lilac[75],
                      size: 7.5,
                    ),
            _ => const SizedBox.shrink(),
          }
        ],
      ),
      titleTextStyle: textTheme.display2(
        Palette.neutral[80],
        FontWeight.w400,
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              contactListItem.description != null &&
                      contactListItem.description!.isNotEmpty
                  ? contactListItem.description!
                  : switch (contactListItem.messageType) {
                      ChatMessageType.newContact => copy.newContact,
                      ChatMessageType.fundsReceived => copy.hasSentYouFunds,
                      ChatMessageType.fundsSent =>
                        contactListItem.messageStatus != null &&
                                contactListItem.messageStatus ==
                                    ChatMessageStatus.sent
                            ? copy.fundsSentSuccessfully
                            : copy.failedToSendFunds,
                      _ => '',
                    },
              style: textTheme.display1(
                Palette.neutral[60],
                FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            width: kSpacing12,
          ),
          Text(
            contactListItem.dateTime,
            style: textTheme.caption1(
              Palette.neutral[60],
              FontWeight.w400,
            ),
          ),
        ],
      ),
      onTap: () => router.pushNamed(
        AppRoute.chat.name,
        pathParameters: {'id': contactListItem.contactId.toString()},
      ),
    );
  }
}
