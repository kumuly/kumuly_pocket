import 'dart:convert';

import 'package:kumuly_pocket/entities/contact_entity.dart';
import 'package:kumuly_pocket/entities/chat_message_entity.dart';
import 'package:kumuly_pocket/enums/chat_message_type.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:kumuly_pocket/repositories/chat_message_repository.dart';
import 'package:kumuly_pocket/repositories/contact_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';

part 'chat_service.g.dart';

abstract class ChatService {
  Future<void> addNewContact(ContactEntity contact);
  Future<List<ContactEntity>> getFrequentContacts({int? limit, int? offset});
  Future<List<ChatMessageEntity>> getMostRecentMessageOfContacts({
    int? limit,
    int? offset,
  });
  Future<List<ChatMessageEntity>> getMessagesByContactId(
    String contactId, {
    int? limit,
    int? offset,
  });
  Future<ContactEntity?> getContactById(String contactId);
  Future<void> sendToContact(String contactId, int amountSat);
  Future<void> retrySendToContact(String messageId);
}

@riverpod
ChatService sqliteChatService(SqliteChatServiceRef ref) {
  return SqliteChatService(
    db: ref.watch(sqliteProvider),
    contactRepository: ref.watch(sqliteContactRepositoryProvider),
    chatMessageRepository: ref.watch(sqliteChatMessageRepositoryProvider),
  );
}

class SqliteChatService implements ChatService {
  SqliteChatService({
    required this.db,
    required this.contactRepository,
    required this.chatMessageRepository,
  });

  final Database db;
  final ContactRepository contactRepository;
  final ChatMessageRepository chatMessageRepository;

  @override
  Future<void> addNewContact(ContactEntity contact) async {
    // Todo: check if contact already exists, and if so, update it instead of creating a new one
    // update only the name and avatar and do not create a new chat message

    // Create a transaction to save the contact and the new contact message atomically
    await db.transaction((tx) async {
      // Since this message is not linked to a payment, we do not have a paymenthash to use as id
      // So we create a hash from the contact id and the timestamp
      final chatMessageId = sha256
          .convert(utf8.encode(contact.id + contact.createdAt.toString()))
          .toString();

      // Save contact to database
      await contactRepository.saveContact(contact, tx: tx);
      // Add new contact message to chat
      await chatMessageRepository.saveMessage(
        ChatMessageEntity(
          id: chatMessageId,
          contactId: contact.id,
          type: ChatMessageType.newContact,
          createdAt: contact.createdAt,
        ),
        tx: tx,
      );
    });
  }

  @override
  Future<List<ContactEntity>> getFrequentContacts({
    int? limit,
    int? offset,
  }) async {
    final contactIds =
        await chatMessageRepository.queryContactIdsOrderedByMessageCount(
      limit: limit,
      offset: offset,
    );

    final futures = contactIds.map(
      (id) => contactRepository.getContactById(id),
    );

    // Wait for all futures to complete
    final List<ContactEntity?> contacts = await Future.wait(futures);

    // Remove null values and return the list
    return contacts
        .where((contact) => contact != null)
        .cast<ContactEntity>()
        .toList();
  }

  @override
  Future<List<ChatMessageEntity>> getMostRecentMessageOfContacts({
    int? limit,
    int? offset,
  }) {
    return chatMessageRepository.queryMostRecentMessageOfContacts(
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<List<ChatMessageEntity>> getMessagesByContactId(
    String contactId, {
    int? limit,
    int? offset,
  }) {
    return chatMessageRepository.queryMessages(
      where: 'contactId = ?', // SQL where clause
      whereArgs: [contactId], // Arguments for the where clause
      orderBy: 'createdAt DESC', // Order by createdAt in descending order
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<ContactEntity?> getContactById(String contactId) {
    return contactRepository.getContactById(contactId);
  }

  @override
  Future<void> retrySendToContact(String messageId) {
    // TODO: implement retrySendToContact
    throw UnimplementedError();
  }

  @override
  Future<void> sendToContact(String contactId, int amountSat) {
    // TODO: implement sendToContact
    throw UnimplementedError();
  }
}
