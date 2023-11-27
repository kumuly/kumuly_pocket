import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kumuly_pocket/view_models/frequent_contact_item.dart';

@immutable
class FrequentContactsState extends Equatable {
  const FrequentContactsState({
    this.contacts = const [],
    this.contactsOffset = 0,
    required this.contactsLimit,
    this.hasMoreContacts = true,
  });

  final List<FrequentContactItem> contacts;
  final int contactsOffset;
  final int contactsLimit;
  final bool hasMoreContacts;

  FrequentContactsState copyWith({
    List<FrequentContactItem>? contacts,
    int? contactsOffset,
    int? contactsLimit,
    bool? hasMoreContacts,
  }) {
    return FrequentContactsState(
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
