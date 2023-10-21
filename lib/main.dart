import 'package:breez_sdk/breez_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:kumuly_pocket/app.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

/* multiple instances test
  final instance1 = BreezSDK();
  final instance2 = BreezSDK();
  print(instance1 == instance2);
  instance1.initialize();
  print('Instance1 isInit: ${await instance1.isInitialized()}');
  instance2.initialize();
  print('Instance2 isInit: ${await instance2.isInitialized()}');

  // Gives:
  // false
  // Instance1 isInit: false
  // Instance2 isInit: false
  */

  // Since shared preferences is not async, we need to initialize it before the
  //  provider scope is created and then override the provider with the
  //  initialized value as to have a synchronous provider and not a future
  //  provider.
  final sharedPreferences = await SharedPreferences.getInstance();

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
      ],
      child: const KumulyPocketApp(),
    ),
  );
}
