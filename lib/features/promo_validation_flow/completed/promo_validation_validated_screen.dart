import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/promo_validation_flow/redemption/promo_validation_redemption_controller.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';

class PromoValidationValidatedScreen extends ConsumerWidget {
  const PromoValidationValidatedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);

    final amountSat =
        ref.watch(promoValidationRedemptionControllerProvider).amountSat;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Palette.neutral[100]!,
              size: 24.0,
            ),
            onPressed: () {
              router.pop();
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: kSpacing6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/illustrations/btc_coins.png',
                    height: 224,
                    width: 224,
                    colorBlendMode: BlendMode.color,
                    color: Palette.success[40]?.withOpacity(0.3),
                  ),
                ),
                const SizedBox(height: kSpacing2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '+ $amountSat ',
                      style: textTheme.display5(
                          Palette.success[40], FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      ref.watch(bitcoinUnitProvider).name.toUpperCase(),
                      style: textTheme.display2(
                        Palette.success[40],
                        FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Palette.success[10],
                  radius: 24,
                  child: CircleAvatar(
                    backgroundColor: Palette.success[40],
                    radius: 16,
                    child: const DynamicIcon(
                      icon: 'assets/icons/check.svg',
                      color: Colors.white,
                      size: 12.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: kSpacing2,
                ),
                Text(
                  copy.promoValidated,
                  style: textTheme.display6(
                    Palette.neutral[120],
                    FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  copy.pleaseProvideProductOrService,
                  style: textTheme.body3(
                    Palette.neutral[70],
                    FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
