import 'package:kumuly_pocket/entities/contact_entity.dart';
import 'package:kumuly_pocket/entities/chat_message_entity.dart';
import 'package:kumuly_pocket/enums/chat_message_status.dart';
import 'package:kumuly_pocket/enums/chat_message_type.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:kumuly_pocket/repositories/chat_message_repository.dart';
import 'package:kumuly_pocket/repositories/contact_repository.dart';
import 'package:kumuly_pocket/services/lightning_node/impl/breez_sdk_lightning_node_service.dart';
import 'package:kumuly_pocket/services/lightning_node/lightning_node_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'chat_service.g.dart';

abstract class ChatService {
  Future<int> addNewContact(ContactEntity contact);
  Future<List<ContactEntity>> getFrequentContacts({int? limit, int? offset});
  Future<List<ChatMessageEntity>> getMostRecentMessageOfContacts({
    int? limit,
    int? offset,
  });
  Future<List<ChatMessageEntity>> getMessagesByContactId(
    int contactId, {
    int? limit,
    int? offset,
  });
  Future<ContactEntity?> getContactById(int contactId);
  Future<void> sendToNodeIdOfContact(int contactId, int amountSat);
  Future<void> retrySendToNodeIdOfContact(
    int messageId,
    int contactId,
    int amountSat,
  );
}

@riverpod
ChatService sqliteChatService(SqliteChatServiceRef ref) {
  return SqliteChatService(
    db: ref.watch(sqliteProvider).requireValue,
    contactRepository: ref.watch(sqliteContactRepositoryProvider),
    chatMessageRepository: ref.watch(sqliteChatMessageRepositoryProvider),
    lightningNodeService: ref.watch(breezeSdkLightningNodeServiceProvider),
    ref: ref,
  );
}

class SqliteChatService implements ChatService {
  SqliteChatService({
    required this.db,
    required this.contactRepository,
    required this.chatMessageRepository,
    required this.lightningNodeService,
    required this.ref,
  });

  final Database db;
  final ContactRepository contactRepository;
  final ChatMessageRepository chatMessageRepository;
  final LightningNodeService lightningNodeService;
  final SqliteChatServiceRef ref;

  @override
  Future<int> addNewContact(ContactEntity contact) async {
    // Todo: check if contact already exists (payment ids and/or name), and if so, update it instead of creating a new one
    // update only the name and avatar and do not create a new chat message

    int? contactId;

    // Create a transaction to save the contact and the new contact message atomically
    await db.transaction((tx) async {
      // Save contact to database
      contactId = await contactRepository.saveContact(contact, tx: tx);
      // Add new contact message to chat
      await chatMessageRepository.saveMessage(
        ChatMessageEntity(
          contactId: contactId!,
          type: ChatMessageType.newContact,
          createdAt: contact.createdAt,
        ),
        tx: tx,
      );
    });

    if (contactId == null) {
      throw Exception('Contact not saved');
    }
    return contactId!;
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
    int contactId, {
    int? limit,
    int? offset,
  }) {
    return chatMessageRepository.queryMessages(
      columns: ['rowid', '*'],
      where: 'contactId = ?', // SQL where clause
      whereArgs: [contactId], // Arguments for the where clause
      orderBy: 'createdAt DESC', // Order by createdAt in descending order
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<ContactEntity?> getContactById(int contactId) {
    return contactRepository.getContactById(contactId);
  }

  @override
  Future<void> sendToNodeIdOfContact(int contactId, int amountSat) async {
    // Try to then send to node, then update message status
    try {
      // Get contact's node id
      final contact = await contactRepository.getContactById(contactId);
      if (contact == null) {
        // Todo: create a custom exception to throw here
        throw Exception('Contact not found');
      }
      if (contact.nodeId == null || contact.nodeId!.isEmpty) {
        // Todo: create a custom exception to throw here
        throw Exception('Contact without node id');
      }

      final keysendResult =
          await lightningNodeService.keysend(contact.nodeId!, amountSat);
      // Save message in database with status sent
      await chatMessageRepository.saveMessage(
        ChatMessageEntity(
          contactId: contactId,
          type: ChatMessageType.fundsSent,
          status: ChatMessageStatus.sent,
          paymentHash: keysendResult.paymentHash,
          amountSat: amountSat,
          isRead: true,
          createdAt: keysendResult.paymentTime,
        ),
      );
      print('Message send with keysendResult: $keysendResult');
    } catch (e) {
      print(e);
      // Save message in database with status failed
      await chatMessageRepository.saveMessage(
        ChatMessageEntity(
          contactId: contactId,
          type: ChatMessageType.fundsSent,
          status: ChatMessageStatus.failed,
          amountSat: amountSat,
          isRead: true,
          createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        ),
      );
      rethrow; // Todo: create a custom exception to throw here
    }
  }

  @override
  Future<void> retrySendToNodeIdOfContact(
    int messageId,
    int contactId,
    int amountSat,
  ) async {
    // Todo: obtain message info from database
    // Todo: compare contactId and amountSat with the ones from the database, to make sure what the user sees is what will be sent

    try {
      // Get contact's node id
      final contact = await contactRepository.getContactById(contactId);
      if (contact == null) {
        // Todo: create a custom exception to throw here
        throw Exception('Contact not found');
      }
      if (contact.nodeId == null || contact.nodeId!.isEmpty) {
        // Todo: create a custom exception to throw here
        throw Exception('Contact without node id');
      }
      final keysendResult =
          await lightningNodeService.keysend(contact.nodeId!, amountSat);
      // Save message in database with status sent
      await chatMessageRepository.saveMessage(
        ChatMessageEntity(
          id: messageId,
          contactId: contactId,
          type: ChatMessageType.fundsSent,
          status: ChatMessageStatus.sent,
          paymentHash: keysendResult.paymentHash,
          amountSat: amountSat,
          isRead: true,
          createdAt: keysendResult.paymentTime,
        ),
      );
      print('Message send with keysendResult: $keysendResult');
    } catch (e) {
      print(e);
      // Save message in database with status failed
      await chatMessageRepository.saveMessage(
        ChatMessageEntity(
          id: messageId,
          contactId: contactId,
          type: ChatMessageType.fundsSent,
          status: ChatMessageStatus.failed,
          amountSat: amountSat,
          isRead: true,
          createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        ),
      );
      rethrow; // Todo: create a custom exception to throw here
    }
  }
}
