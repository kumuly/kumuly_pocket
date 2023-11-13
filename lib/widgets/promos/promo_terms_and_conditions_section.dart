import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/lists/numbered_list.dart';

class PromoTermsAndConditionsSection extends StatelessWidget {
  const PromoTermsAndConditionsSection(
    this.termsAndConditions, {
    Key? key,
  }) : super(key: key);

  final List<String> termsAndConditions;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          copy.promoTermsAndConditionsTitle,
          style: textTheme.display2(
            Palette.neutral[120],
            FontWeight.w500,
            wordSpacing: 0,
          ),
        ),
        const SizedBox(height: 12.0),
        NumberedList(listItems: termsAndConditions),
      ],
    );
  }
}
