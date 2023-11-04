import 'package:flutter/material.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            termsAndConditions.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${index + 1}.'),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: Text(
                      termsAndConditions[index],
                      style: Theme.of(context).textTheme.body3(
                            Palette.neutral[70],
                            FontWeight.w400,
                            wordSpacing: 0,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
