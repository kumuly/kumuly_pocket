import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PromoPaidScreen extends StatelessWidget {
  const PromoPaidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promo Paid Screen'),
      ),
      body: const Center(
        child: Text(
          'Promo Paid Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
