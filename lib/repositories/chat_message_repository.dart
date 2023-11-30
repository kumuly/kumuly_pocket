import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/entities/chat_message_entity.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'chat_message_repository.g.dart';

abstract class ChatMessageRepository {
  Future<int> saveMessage(ChatMessageEntity message, {dynamic tx});
  Future<void> deleteMessage(int id);
  Future<List<ChatMessageEntity>> queryMessages({
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  });
  Future<List<int>> queryContactIdsOrderedByMessageCount({
    int? limit,
    int? offset,
  });
  Future<List<ChatMessageEntity>> queryMostRecentMessageOfContacts({
    int? limit,
    int? offset,
  });
}

@riverpod
ChatMessageRepository sqliteChatMessageRepository(
    SqliteChatMessageRepositoryRef ref) {
  return SqliteChatMessageRepository(
    db: ref.watch(sqliteProvider),
  );
}

class SqliteChatMessageRepository implements ChatMessageRepository {
  SqliteChatMessageRepository({required this.db});

  final Database db;

  @override
  Future<int> saveMessage(
    ChatMessageEntity message, {
    dynamic tx,
  }) {
    // Save contact to database
    if (tx == null) {
      return db.insert(
        kChatMessagesTable,
        message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      return (tx as Transaction).insert(
        kChatMessagesTable,
        message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  @override
  Future<void> deleteMessage(int id) {
    return db.delete(
      kChatMessagesTable,
      where: 'rowid = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<ChatMessageEntity>> queryMessages({
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final messages = await db.query(
      kChatMessagesTable,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
    return messages.map((e) => ChatMessageEntity.fromMap(e)).toList();
  }

  @override
  Future<List<int>> queryContactIdsOrderedByMessageCount(
      {int? limit, int? offset}) async {
    String query = 'SELECT contactId, COUNT(*) as messageCount '
        'FROM $kChatMessagesTable '
        'GROUP BY contactId '
        'ORDER BY messageCount DESC';

    // Adding LIMIT and OFFSET clauses if they are provided
    if (limit != null) {
      query += ' LIMIT $limit';
      if (offset != null) {
        query += ' OFFSET $offset';
      }
    }

    final results = await db.rawQuery(query);
    return results.map((row) => row['contactId'] as int).toList();
  }

  @override
  Future<List<ChatMessageEntity>> queryMostRecentMessageOfContacts({
    int? limit,
    int? offset,
  }) async {
    String subquery = 'SELECT contactId, MAX(createdAt) as maxCreatedAt '
        'FROM $kChatMessagesTable '
        'GROUP BY contactId';

    String query = 'SELECT M.rowid, M.* FROM $kChatMessagesTable M '
        'INNER JOIN ($subquery) as Sub ON M.contactId = Sub.contactId AND M.createdAt = Sub.maxCreatedAt '
        'ORDER BY M.createdAt DESC';

    // Adding LIMIT and OFFSET clauses if they are provided
    if (limit != null) {
      query += ' LIMIT $limit';
      if (offset != null) {
        query += ' OFFSET $offset';
      }
    }

    final results = await db.rawQuery(query);
    print('queryMostRecentMessageOfContacts: $results');
    return results.map((row) {
      print('queryMostRecentMessageOfContacts row: $row');
      return ChatMessageEntity.fromMap(row);
    }).toList();
  }
}
