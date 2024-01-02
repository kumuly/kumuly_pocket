import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';

class SeedImportCompletedScreen extends StatelessWidget {
  const SeedImportCompletedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);

    return Scaffold(
      body: PrimaryFilledButton(
        onPressed: () => router.goNamed('pocket'),
        text: 'Seed import completed',
      ),
    );
  }
}
