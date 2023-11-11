import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          copy.createAccount,
          style: textTheme.display4(
            Palette.neutral[100]!,
            FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.white,
        iconTheme: IconThemeData(color: Palette.neutral[100]!),
      ),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: kSpacing3),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: textTheme.body2(
                      Palette.neutral[100]!.withOpacity(0.3),
                      FontWeight.w400,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${copy.accountCreationPolicyPart1} ',
                      ),
                      TextSpan(
                        text: copy.accountCreationPolicyPart2,
                        style: textTheme.body2(
                          Palette.neutral[100]!.withOpacity(0.7),
                          FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: ' ${copy.accountCreationPolicyPart3} '),
                      TextSpan(
                        text: copy.accountCreationPolicyPart4,
                        style: textTheme.body2(
                          Palette.neutral[100]!.withOpacity(0.7),
                          FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
                const SizedBox(height: kSpacing2),
                Text(
                  copy.noDataCollectedOrSharedForCommercialPurposes,
                  style: textTheme.body2(
                    Palette.neutral[100]!.withOpacity(0.3),
                    FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          const SizedBox(height: kSpacing8),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PrimaryFilledButton(
                text: copy.continueLabel,
                onPressed: () => context.pushNamed('assign-alias'),
              ),
            ],
          ),
          const SizedBox(height: kSpacing3),
        ],
      ),
    );
  }
}
