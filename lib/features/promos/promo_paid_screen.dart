import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/backgrounds/background_container.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';

class PromoPaidScreen extends StatelessWidget {
  const PromoPaidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);
    final textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: () async {
        router.goNamed('for-you');
        return false; // Prevent the default behavior (closing the app or popping the route)
      },
      child: Scaffold(
        body: BackgroundContainer(
          assetName: 'assets/backgrounds/green_success_background.png',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 48,
                      child: DynamicIcon(
                        icon: 'assets/icons/check.svg',
                        color: Palette.success[40],
                        size: 31,
                      ),
                    ),
                    const SizedBox(height: kSmallSpacing),
                    Text(
                      copy.paymentCompleted,
                      style: textTheme.display4(
                        Palette.success[20],
                        FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          copy.promoCodeReceived,
                          style: textTheme.display6(
                            Colors.white,
                            FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: kExtraSmallSpacing),
                        Text(
                          copy.checkOutGuidelinesToRedeemPromo,
                          textAlign: TextAlign.center,
                          style: textTheme.body3(
                            Colors.white,
                            FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    PrimaryTextButton(
                      color: Colors.white,
                      text: copy.redemptionInstructions,
                      trailingIcon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Color.fromRGBO(255, 255, 255, 1),
                        size: 12,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
