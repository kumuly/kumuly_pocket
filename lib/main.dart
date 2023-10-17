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

  // Since shared preferences is not async, we need to initialize it before the
  //  provider scope is created and then override the provider with the
  //  initialized value as to have a synchronous provider and not a future
  //  provider.
  final sharedPreferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.playIntegrity,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
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
