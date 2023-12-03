import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/local_currency.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/buttons/radio_button.dart';

class LocalCurrencySettingsScreen extends ConsumerWidget {
  const LocalCurrencySettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);

    final localCurrency = ref.watch(localCurrencyProvider);

    localCurrencySelectionHandler(LocalCurrency currency) {
      ref
          .read(sharedPreferencesProvider)
          .setString(kLocalCurrencySettingsKey, currency.name)
          .then((value) => ref.refresh(localCurrencyProvider));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          copy.localCurrency,
          style: textTheme.display4(
            Palette.neutral[100]!,
            FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: router.pop,
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Column(
                children: LocalCurrency.values
                    .map(
                      (currency) => ListTile(
                        onTap: () => localCurrencySelectionHandler(currency),
                        title: Text(
                          '${currency.flag} ${currency.name} (${currency.symbol}${currency.symbol.isNotEmpty ? ' ' : ''}${currency.code})',
                          style: textTheme.display3(
                            Palette.neutral[80],
                            FontWeight.normal,
                          ),
                        ),
                        leading:
                            RadioButton(isSelected: localCurrency == currency),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
