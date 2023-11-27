import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/view_models/contact_list_item.dart';

@immutable
class ContactListState extends Equatable {
  const ContactListState({
    this.contacts = const [],
    this.contactsOffset = 0,
    required this.contactsLimit,
    this.hasMoreContacts = true,
  });

  final List<ContactListItem> contacts;
  final int contactsOffset;
  final int contactsLimit;
  final bool hasMoreContacts;

  ContactListState copyWith({
    List<ContactListItem>? contacts,
    int? contactsOffset,
    int? contactsLimit,
    bool? hasMoreContacts,
  }) {
    return ContactListState(
      contacts: contacts ?? this.contacts,
      contactsOffset: contactsOffset ?? this.contactsOffset,
      contactsLimit: contactsLimit ?? this.contactsLimit,
      hasMoreContacts: hasMoreContacts ?? this.hasMoreContacts,
    );
  }

  @override
  List<Object?> get props => [
        contacts,
        contactsOffset,
        contactsLimit,
        hasMoreContacts,
      ];
}
