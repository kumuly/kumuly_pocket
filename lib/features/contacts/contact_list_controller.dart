import 'package:kumuly_pocket/entities/chat_message_entity.dart';
import 'package:kumuly_pocket/enums/chat_message_type.dart';
import 'package:kumuly_pocket/enums/payment_direction.dart';
import 'package:kumuly_pocket/features/contacts/contact_list_state.dart';
import 'package:kumuly_pocket/repositories/contact_repository.dart';
import 'package:kumuly_pocket/services/chat_service.dart';
import 'package:kumuly_pocket/view_models/contact_list_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contact_list_controller.g.dart';

@riverpod
class ContactListController extends _$ContactListController {
  @override
  FutureOr<ContactListState> build(int contactsLimit) async {
    final messages =
        await ref.read(sqliteChatServiceProvider).getMostRecentMessageByContact(
              limit: contactsLimit,
            );
    final contactListItems = await _messagesToContactListItems(messages);

    return ContactListState(
      contactsLimit: contactsLimit,
      contacts: contactListItems,
      contactsOffset: contactListItems.length,
      hasMoreContacts: contactListItems.length == contactsLimit,
    );
  }

  Future<void> fetchContacts({bool refresh = false}) async {
    await update((state) async {
      // Fetch contacts
      final messages = await ref
          .read(sqliteChatServiceProvider)
          .getMostRecentMessageByContact(
            limit: state.contactsLimit,
            offset: refresh ? null : state.contactsOffset,
          );
      final contactListItems = await _messagesToContactListItems(messages);

      // Update state
      return state.copyWith(
        contacts: refresh
            ? contactListItems
            : [
                ...state.contacts,
                ...contactListItems,
              ],
        contactsOffset: state.contactsOffset + contactListItems.length,
        hasMoreContacts: contactListItems.length == state.contactsLimit,
      );
    });
  }

  Future<List<ContactListItem>> _messagesToContactListItems(
      List<ChatMessageEntity> messages) async {
    final futures = messages.map((message) async {
      final contact = await ref
          .read(sqliteContactRepositoryProvider)
          .getContactById(message.contactId);

      if (contact == null) {
        return null;
      }

      return ContactListItem(
        contactId: contact.id,
        contactName: contact.name,
        contactImagePath: contact.avatarImagePath,
        //description: message.description,
        timestamp: message.createdAt,
        direction: message.type == ChatMessageType.fundsReceived
            ? PaymentDirection.incoming
            : message.type == ChatMessageType.fundsSent
                ? PaymentDirection.outgoing
                : null, // Todo: Replace with type here too
        isNewContact: message.type == ChatMessageType.newContact,
        hasUnreadMessage: !message.isRead,
      );
    });

    // Wait for all futures to complete
    final List<ContactListItem?> contacts = await Future.wait(futures);

    // Remove null values and return the list
    return contacts
        .where((contact) => contact != null)
        .cast<ContactListItem>()
        .toList();
  }
}
