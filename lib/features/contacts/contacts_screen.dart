import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/payment_direction.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/view_models/last_contact_message.dart';
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
          left: kSpacing2,
          right: kSpacing2,
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
                        hintText: 'Search a contact',
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
                        return index == 0
                            ? _buildAddContactItem(
                                textTheme,
                              ) // The first item (Add contact)
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: kSpacing1 * 3.5),
                                child: _buildFrequentContactItem(textTheme),
                              ); // Other items (Frequent contacts)
                      },
                    ),
                  ),
                  ContactsList(
                    lastContactMessages: const [
                      LastContactMessage(
                        contactName: "Courtney Henry",
                        description: 'Buy something nice for yourself.',
                        amountSat: 100000,
                        direction: PaymentDirection.incoming,
                        timestamp: 128383833,
                      ),
                      LastContactMessage(contactName: "Jacob Jones"),
                      LastContactMessage(contactName: "Courtney Henry"),
                      LastContactMessage(contactName: "Jacob Jones"),
                      LastContactMessage(contactName: "Courtney Henry"),
                      LastContactMessage(contactName: "Jacob Jones"),
                      LastContactMessage(contactName: "Courtney Henry"),
                      LastContactMessage(contactName: "Jacob Jones"),
                      LastContactMessage(contactName: "Courtney Henry"),
                      LastContactMessage(contactName: "Jacob Jones"),
                      LastContactMessage(contactName: "Courtney Henry"),
                      LastContactMessage(contactName: "Jacob Jones"),
                    ],
                    loadLatestContactMessages: (
                        {bool refresh = false}) async {},
                    limit: 10,
                    hasMore: false,
                    isLoading: false,
                    isLoadingError: false,
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

Widget _buildAddContactItem(TextTheme textTheme) {
  return InkWell(
    child: Column(
      children: [
        CircleAvatar(
          backgroundColor: Palette.neutral[120],
          radius: 28,
          child: const DynamicIcon(
            icon: 'assets/icons/add_contact.svg',
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: kSpacing1),
        Text(
          'Add',
          style: textTheme.display1(
            Palette.neutral[80],
            FontWeight.w400,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildFrequentContactItem(TextTheme textTheme) {
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
              Palette.neutral[80],
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
