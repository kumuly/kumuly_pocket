import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/payment_direction.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/last_contact_message.dart';
import 'package:kumuly_pocket/widgets/lists/lazy_list.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({
    super.key,
    required this.lastContactMessages,
    required this.loadLatestContactMessages,
    required this.limit,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingError = false,
  });

  final List<LastContactMessage> lastContactMessages;
  final Future<void> Function({bool refresh}) loadLatestContactMessages;
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
          items: lastContactMessages
              .map(
                (lastContactMessages) => LastContactMessageItem(
                  lastContactMessages,
                  key: Key(
                    lastContactMessages.contactName,
                  ),
                ),
              )
              .toList(),
          loadItems: loadLatestContactMessages,
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

class LastContactMessageItem extends ConsumerWidget {
  const LastContactMessageItem(this.lastContactMessage, {required super.key});

  final LastContactMessage lastContactMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final unit = ref.watch(bitcoinUnitProvider);

    return ListTile(
      horizontalTitleGap: 12,
      minVerticalPadding: kSpacing2 * 1.5,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      leading: lastContactMessage.contactImagePath != null
          ? CircleAvatar(
              radius: 16,
              backgroundImage:
                  FileImage(File(lastContactMessage.contactImagePath!)),
            )
          : CircleAvatar(
              backgroundColor: Palette.neutral[20],
              radius: 16,
              child: const Icon(Icons.person,
                  size: 12.5), // Default icon if no image is selected
            ),
      title: Text(lastContactMessage.contactName),
      titleTextStyle: textTheme.display2(
        Palette.neutral[80],
        FontWeight.w400,
      ),
      subtitle: lastContactMessage.description != null
          ? Text(
              lastContactMessage.description!,
              style: textTheme.caption1(
                Palette.neutral[60],
                FontWeight.w400,
              ),
            )
          : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          lastContactMessage.amountSat == null
              ? const SizedBox.shrink()
              : Text(
                  '${lastContactMessage.direction == PaymentDirection.incoming ? '+' : '-'} ${ref.watch(displayBitcoinAmountProvider(lastContactMessage.amountSat))} ${unit.name.toUpperCase()}',
                  style: textTheme.display2(
                    lastContactMessage.direction == PaymentDirection.incoming
                        ? Palette.success[50]
                        : Palette.neutral[70],
                    FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                ),
          const SizedBox(
            height: 4,
          ),
          lastContactMessage.timestamp == null
              ? const SizedBox.shrink()
              : Text(
                  lastContactMessage.dateTime,
                  style: textTheme.caption1(
                    Palette.neutral[60],
                    FontWeight.w400,
                  ),
                  textAlign: TextAlign.end,
                ),
        ],
      ),
    );
  }
}
