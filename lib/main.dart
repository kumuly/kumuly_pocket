import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/app_startup.dart';

import 'package:kumuly_pocket/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, // Only allow portrait mode
  ]);

  runApp(
    ProviderScope(
      child: AppStartupWidget(
        onLoaded: (context) => const KumulyPocketApp(),
      ),
    ),
  );
}
