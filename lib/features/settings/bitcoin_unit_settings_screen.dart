import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';
import 'package:kumuly_pocket/widgets/buttons/radio_button.dart';

class BitcoinUnitSettingsScreen extends ConsumerWidget {
  const BitcoinUnitSettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);

    final bitcoinUnit = ref.watch(bitcoinUnitProvider);

    bitcoinUnitSelectionHandler(BitcoinUnit unit) {
      ref
          .read(sharedPreferencesProvider)
          .requireValue
          .setString(kBitcoinUnitSettingsKey, unit.name)
          .then((value) => ref.refresh(bitcoinUnitProvider));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          copy.bitcoinUnit,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ListTile(
              onTap: () => bitcoinUnitSelectionHandler(BitcoinUnit.btc),
              title: Text(
                copy.btcUnit,
                style: textTheme.display3(
                  Palette.neutral[80],
                  FontWeight.normal,
                ),
              ),
              leading: RadioButton(isSelected: bitcoinUnit == BitcoinUnit.btc),
            ),
            ListTile(
              onTap: () => bitcoinUnitSelectionHandler(BitcoinUnit.sat),
              title: Text(
                copy.satUnit,
                style: textTheme.display3(
                  Palette.neutral[80],
                  FontWeight.normal,
                ),
              ),
              leading: RadioButton(isSelected: bitcoinUnit == BitcoinUnit.sat),
            ),
            const SizedBox(height: 8.0),
            if (bitcoinUnit == BitcoinUnit.sat)
              BounceInUp(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  child: Text(
                    copy.satUnitHelperText,
                    style: textTheme.body2(
                      Palette.neutral[70],
                      FontWeight.normal,
                    ),
                  ),
                ),
              ),
            const Spacer(),
            Text(
              copy.usingSatsMakesYourLifeEasier,
              style: textTheme.body4(
                Palette.neutral[60],
                FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            PrimaryTextButton(
              text: copy.getToKnowMore,
              trailingIcon: const Icon(Icons.chevron_right),
              color: Palette.russianViolet[100],
              onPressed: () {},
            ),
            const SizedBox(height: 72.0),
          ],
        ),
      ),
    );
  }
}
