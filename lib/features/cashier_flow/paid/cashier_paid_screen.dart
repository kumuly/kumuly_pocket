import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/local_currency.dart';
import 'package:kumuly_pocket/features/cashier_flow/generation/cashier_generation_controller.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/amounts/bitcoin_amount_display.dart';
import 'package:kumuly_pocket/widgets/amounts/local_currency_amount_display.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class CashierPaidScreen extends ConsumerWidget {
  const CashierPaidScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final amountSat = ref.watch(cashierGenerationControllerProvider).amountSat;

    final copy = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Palette.neutral[100]!,
              size: 24.0,
            ),
            onPressed: () {
              // Reset the state
              ref.invalidate(cashierGenerationControllerProvider);
              ref
                  .watch(pageViewControllerProvider(
                    kCashierFlowPageViewId,
                  ))
                  .pageController
                  .jumpToPage(0);
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Column(
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
                  BitcoinAmountDisplay(
                    prefix: '+ ',
                    amountSat: amountSat,
                    amountStyle: textTheme.display7(
                      Palette.success[40],
                      FontWeight.w600,
                    ),
                    unitCodeStyle: textTheme.display2(
                      Palette.success[40],
                      FontWeight.w500,
                    ),
                    unitSymbolStyle: textTheme.display2(
                      Palette.success[40],
                      FontWeight.w500,
                    ),
                  ),
                ],
              ),
              LocalCurrencyAmountDisplay(
                prefix: '≈ ',
                amountSat: amountSat,
                amountStyle: textTheme.display2(
                  Palette.neutral[80],
                  FontWeight.w400,
                ),
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
                    icon: 'assets/icons/receive_arrow.svg',
                    color: Colors.white,
                    size: 12.0,
                  ),
                ),
              ),
              const SizedBox(
                height: kSpacing2,
              ),
              Text(
                copy.fundsReceived,
                style: textTheme.display6(
                  Palette.neutral[120],
                  FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                copy.availableInSalesBalance,
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
    );
  }
}
