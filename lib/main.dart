import 'package:breez_sdk/breez_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/providers/breez_sdk_providers.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:kumuly_pocket/app.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Since shared preferences is not async, we need to initialize it before the
  //  provider scope is created and then override the provider with the
  //  initialized value as to have a synchronous provider and not a future
  //  provider.
  final sharedPreferences = await SharedPreferences.getInstance();

  // The same for initializing the Breez SDK.
  final breezSdk = BreezSDK();
  if (!(await breezSdk.isInitialized())) {
    breezSdk.initialize();
  }

  // The same for the sqlite db
  final sqliteDb = await openDatabase(
    join(await getDatabasesPath(), 'kumuly_pocket.db'),
    onCreate: (db, version) async {
      // Create the contacts and messages table
      await db.execute(
        'CREATE TABLE $kContactsTable('
        'id TEXT PRIMARY KEY, '
        'name TEXT, '
        'avatarImagePath TEXT, '
        'createdAt INTEGER'
        ')',
      );
      return db.execute(
        'CREATE TABLE $kChatMessagesTable('
        'id TEXT NOT NULL PRIMARY KEY, '
        'contactId TEXT NOT NULL, '
        'type TEXT NOT NULL, '
        'amountSat INTEGER NOT NULL, '
        'isRead INTEGER DEFAULT 0, '
        'createdAt INTEGER NOT NULL, '
        'FOREIGN KEY(contactId) REFERENCES $kContactsTable(id)'
        ')',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider:
        kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.appAttest,
  );

  runApp(
    ProviderScope(
      overrides: [
        // override the previous value with the new object
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        breezSdkProvider.overrideWithValue(breezSdk),
        sqliteProvider.overrideWithValue(sqliteDb),
      ],
      child: const KumulyPocketApp(),
    ),
  );
}
