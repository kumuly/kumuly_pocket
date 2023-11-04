import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PromoDescriptionSection extends StatelessWidget {
  const PromoDescriptionSection(
    this.description, {
    Key? key,
  }) : super(key: key);

  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          copy.promoDescriptionTitle,
          style: textTheme.display2(
            Palette.neutral[120],
            FontWeight.w500,
            wordSpacing: 0,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          description,
          style: textTheme.body3(
            Palette.neutral[70],
            FontWeight.w400,
            wordSpacing: 0,
          ),
        ),
      ],
    );
  }
}
