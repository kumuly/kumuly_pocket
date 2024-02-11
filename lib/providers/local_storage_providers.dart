import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

part 'local_storage_providers.g.dart';

@riverpod
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return const FlutterSecureStorage();
}

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) {
  return SharedPreferences.getInstance();
}

@Riverpod(keepAlive: true)
Future<Database> sqlite(SqliteRef ref) async {
  return openDatabase(
    join(await getDatabasesPath(), 'kumuly_pocket.db'),
    onCreate: (db, version) async {
      // Create the contacts and messages table
      await db.execute(
        'CREATE TABLE $kContactsTable('
        'name TEXT, '
        'avatarImagePath TEXT, '
        'nodeId TEXT, '
        'bolt12 TEXT, '
        'lightningAddress TEXT, '
        'bitcoinAddress TEXT, '
        'createdAt INTEGER'
        ')',
      );
      return db.execute(
        'CREATE TABLE $kChatMessagesTable('
        'contactId INTEGER NOT NULL, '
        'type TEXT NOT NULL, '
        'status TEXT, '
        'paymentHash TEXT, '
        'amountSat INTEGER NOT NULL, '
        'memo TEXT, '
        'isRead INTEGER DEFAULT 0, '
        'createdAt INTEGER NOT NULL, '
        'FOREIGN KEY(contactId) REFERENCES $kContactsTable(rowid)'
        ')',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
}
