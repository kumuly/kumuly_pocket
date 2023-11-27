import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/entities/contact_entity.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'contact_repository.g.dart';

abstract class ContactRepository {
  Future<void> saveContact(ContactEntity contact, {dynamic tx});
  Future<void> deleteContact(ContactEntity contact);
  Future<List<ContactEntity>> queryContacts({
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
  Future<ContactEntity?> getContactById(String id);
}

@riverpod
ContactRepository sqliteContactRepository(SqliteContactRepositoryRef ref) {
  return SqliteContactRepository(
    db: ref.watch(sqliteProvider),
  );
}

class SqliteContactRepository implements ContactRepository {
  SqliteContactRepository({required this.db});

  final Database db;

  @override
  Future<void> saveContact(
    ContactEntity contact, {
    dynamic tx,
  }) {
    // Save contact to database
    if (tx == null) {
      return db.insert(
        kContactsTable,
        contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      return (tx as Transaction).insert(
        kContactsTable,
        contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  @override
  Future<void> deleteContact(ContactEntity contact) async {
    await db.delete(
      kContactsTable,
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  @override
  Future<List<ContactEntity>> queryContacts({
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
    final contacts = await db.query(
      kContactsTable,
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
    return contacts.map((e) => ContactEntity.fromMap(e)).toList();
  }

  @override
  Future<ContactEntity?> getContactById(String id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      kContactsTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ContactEntity.fromMap(maps.first);
    }

    return null;
  }
}
