import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/payment_direction.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/contact_list_item.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/lists/contacts_list.dart';
import 'package:kumuly_pocket/widgets/shadows/bottom_shadow.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    double screenWidth = MediaQuery.of(context).size.width;
    final router = GoRouter.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
          top: kSpacing6,
        ),
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {},
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
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10 + 1,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(right: kSpacing1 * 3.5),
                          child: index == 0
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: kSpacing2),
                                  child: _buildAddContactItem(
                                    context, // The first item (Add contact)
                                  ),
                                )
                              : _buildFrequentContactItem(
                                  context, // Other items (Frequent contacts)
                                ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kSpacing2,
                    ),
                    child: ContactsList(
                      contactListItems: const [
                        ContactListItem(
                          contactName: "Courtney Henry",
                          description:
                              'Buy something nice for yourself dfdff fdfdf dffd',
                          direction: PaymentDirection.incoming,
                          timestamp: 128383833,
                        ),
                        ContactListItem(
                            contactName: "Jacob Jones", isNewContact: true),
                        ContactListItem(contactName: "Courtney Henry"),
                        ContactListItem(contactName: "Jacob Jones"),
                        ContactListItem(contactName: "Courtney Henry"),
                        ContactListItem(contactName: "Jacob Jones"),
                        ContactListItem(contactName: "Courtney Henry"),
                        ContactListItem(contactName: "Jacob Jones"),
                        ContactListItem(contactName: "Courtney Henry"),
                        ContactListItem(contactName: "Jacob Jones"),
                        ContactListItem(contactName: "Courtney Henry"),
                        ContactListItem(contactName: "Jacob Jones"),
                      ],
                      loadContactListItems: ({bool refresh = false}) async {},
                      limit: 10,
                      hasMore: false,
                      isLoading: false,
                      isLoadingError: false,
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

Widget _buildAddContactItem(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  final router = GoRouter.of(context);
  final copy = AppLocalizations.of(context)!;

  return InkWell(
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
  );
}

Widget _buildFrequentContactItem(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;

  return InkWell(
    child: Column(
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage('assets/images/dummy_avatar.png'),
          radius: 28,
        ),
        const SizedBox(height: kSpacing1),
        SizedBox(
          width: 56,
          child: Text(
            'Savannah',
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
  );
}
