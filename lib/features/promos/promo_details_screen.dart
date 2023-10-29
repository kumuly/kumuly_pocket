import 'package:flutter/material.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PromoDetailsScreen extends StatelessWidget {
  const PromoDetailsScreen({Key? key, required this.promo}) : super(key: key);

  final Promo promo;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(promo.tag),
      ),
      body: const Center(
        child: Text(
          'Promo Details Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
