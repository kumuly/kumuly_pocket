import 'package:kumuly_pocket/features/contacts/frequent_contacts_state.dart';
import 'package:kumuly_pocket/services/chat_service.dart';
import 'package:kumuly_pocket/view_models/frequent_contact_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'frequent_contacts_controller.g.dart';

@riverpod
class FrequentContactsController extends _$FrequentContactsController {
  @override
  FutureOr<FrequentContactsState> build(int contactsLimit) async {
    final contacts =
        await ref.read(sqliteChatServiceProvider).getFrequentContacts(
              limit: contactsLimit,
            );

    return FrequentContactsState(
      contactsLimit: contactsLimit,
      contacts: contacts
          .map((entity) => FrequentContactItem(
              contactId: entity.id!,
              contactName: entity.name,
              contactImagePath: entity.avatarImagePath))
          .toList(),
      contactsOffset: contacts.length,
      hasMoreContacts: contacts.length == contactsLimit,
    );
  }

  Future<void> fetchContacts({bool refresh = false}) async {
    await update((state) async {
      // Fetch payments
      final contactEntities =
          await ref.read(sqliteChatServiceProvider).getFrequentContacts(
                limit: state.contactsLimit,
                offset: refresh ? null : state.contactsOffset,
              );

      // Update state
      return state.copyWith(
        contacts: refresh
            ? contactEntities
                .map((entity) => FrequentContactItem(
                    contactId: entity.id!,
                    contactName: entity.name,
                    contactImagePath: entity.avatarImagePath))
                .toList()
            : [
                ...state.contacts,
                ...contactEntities
                    .map((entity) => FrequentContactItem(
                        contactId: entity.id!,
                        contactName: entity.name,
                        contactImagePath: entity.avatarImagePath))
                    .toList(),
              ],
        contactsOffset: state.contactsOffset + contactEntities.length,
        hasMoreContacts: contactEntities.length == state.contactsLimit,
      );
    });
  }
}
