import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/contacts/contact_list_controller.dart';
import 'package:kumuly_pocket/features/contacts/frequent_contacts_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/lists/contacts_list.dart';
import 'package:kumuly_pocket/widgets/lists/frequent_contacts_list.dart';
import 'package:kumuly_pocket/widgets/shadows/bottom_shadow.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    double screenWidth = MediaQuery.of(context).size.width;

    const frequentContactsLimit = 10;
    final frequentContactsState = ref.watch(
      frequentContactsControllerProvider(frequentContactsLimit),
    );
    final frequentContactsNotifier = ref.read(
      frequentContactsControllerProvider(frequentContactsLimit).notifier,
    );

    const contactListLimit = 10;
    final contactListState = ref.watch(
      contactListControllerProvider(contactListLimit),
    );
    final contactListNotifier = ref.read(
      contactListControllerProvider(contactListLimit).notifier,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
          top: kSpacing6,
        ),
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await frequentContactsNotifier.fetchContacts(refresh: true);
                await contactListNotifier.fetchContacts(refresh: true);
              },
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Search bar
                  Container(
                    padding: const EdgeInsets.only(
                      left: kSpacing2,
                      right: kSpacing2,
                    ),
                    height: 32,
                    color: Colors.transparent,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Palette.neutral[100]!,
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                          maxHeight: 24,
                          maxWidth: 24,
                        ),
                        prefix: const SizedBox(width: kSpacing1),
                        hintText: copy.searchAContact,
                        hintStyle: textTheme.display2(
                          Palette.neutral[50],
                          FontWeight.w500,
                        ),
                      ),
                      style: textTheme.display3(
                        Palette.neutral[100],
                        FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: kSpacing5),
                  // Add contact + frequent/favorite contacts
                  SizedBox(
                    height: 116,
                    child: FrequentContactsList(
                      contactListItems: frequentContactsState.hasValue
                          ? frequentContactsState.asData!.value.contacts
                          : [],
                      loadContactListItems:
                          frequentContactsNotifier.fetchContacts,
                      limit: frequentContactsLimit,
                      hasMore: frequentContactsState.hasValue
                          ? frequentContactsState.asData!.value.hasMoreContacts
                          : true,
                      isLoading: frequentContactsState.isLoading,
                      isLoadingError: frequentContactsState.hasError,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kSpacing2,
                    ),
                    child: ContactsList(
                      contactListItems: contactListState.hasValue
                          ? contactListState.asData!.value.contacts
                          : [],
                      loadContactListItems: contactListNotifier.fetchContacts,
                      limit: contactListLimit,
                      hasMore: contactListState.hasValue
                          ? contactListState.asData!.value.hasMoreContacts
                          : true,
                      isLoading: contactListState.isLoading,
                      isLoadingError: contactListState.hasError,
                    ),
                  ),
                  const SizedBox(
                    height: kSpacing3,
                  ),
                ],
              ),
            ),
            BottomShadow(
              width: screenWidth,
            ),
          ],
        ),
      ),
    );
  }
}
