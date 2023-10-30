import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PromosScreen extends StatelessWidget {
  const PromosScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(copy.promos),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Promos Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
