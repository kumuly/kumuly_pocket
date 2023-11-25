import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/frequent_contact_item.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/lists/lazy_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FrequentContactsList extends StatelessWidget {
  const FrequentContactsList({
    super.key,
    required this.contactListItems,
    required this.loadContactListItems,
    required this.limit,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingError = false,
  });

  final List<FrequentContactItem> contactListItems;
  final Future<void> Function({bool refresh}) loadContactListItems;
  final int limit;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingError;

  @override
  Widget build(context) {
    return LazyList(
      scrollDirection: Axis.horizontal,
      items: [
        const AddContactItem(),
        ...contactListItems
            .map(
              (contactListItem) => FrequentContactItemWidget(
                contactListItem,
                key: Key(
                  contactListItem.contactName,
                ),
              ),
            )
            .toList()
      ],
      loadItems: loadContactListItems,
      limit: limit,
      hasMore: hasMore,
      isLoading: isLoading,
      isLoadingError: isLoadingError,
      emptyIndicator: null, // TODO: implement emptyIndicator
      errorIndicator: null, // TODO: implement errorIndicator
      noMoreItemsIndicator: null, // TODO: implement noMoreItemsIndicator
    );
  }
}

class AddContactItem extends StatelessWidget {
  const AddContactItem({super.key});

  @override
  Widget build(context) {
    final textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(left: kSpacing2, right: kSpacing1 * 3.5),
      child: InkWell(
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Palette.neutral[120],
              radius: 28,
              child: DynamicIcon(
                icon: 'assets/icons/add_contact.svg',
                color: Palette.neutral[30],
                size: 14,
              ),
            ),
            const SizedBox(height: kSpacing1),
            Text(
              copy.add,
              style: textTheme.display1(
                Palette.neutral[100],
                FontWeight.w400,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        onTap: () => router.pushNamed('add-contact-flow'),
      ),
    );
  }
}

class FrequentContactItemWidget extends StatelessWidget {
  const FrequentContactItemWidget(
    this.contact, {
    super.key,
  });

  final FrequentContactItem contact;

  @override
  Widget build(context) {
    final textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: kSpacing1 * 3.5),
      child: InkWell(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: contact.contactImagePath != null
                  ? FileImage(File(contact.contactImagePath!))
                  : null,
              radius: 28,
              backgroundColor: Palette.neutral[20],
              child: contact.contactImagePath == null
                  ? const Icon(Icons.person, size: 24)
                  : null,
            ),
            const SizedBox(height: kSpacing1),
            SizedBox(
              width: 56,
              child: Text(
                contact.contactName,
                style: textTheme.display1(
                  Palette.neutral[100],
                  FontWeight.w400,
                  letterSpacing: -0.5,
                ),
                softWrap: true,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
        onTap: () => router.pushNamed(
          'chat',
          pathParameters: {'id': contact.contactId},
        ),
      ),
    );
  }
}
