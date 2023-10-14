import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kumuly_pocket/app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: KumulyPocketApp(),
    ),
  );
}
