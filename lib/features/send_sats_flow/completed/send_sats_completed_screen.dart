import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/send_sats_flow/send_sats_controller.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendSatsCompletedScreen extends ConsumerWidget {
  const SendSatsCompletedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);

    final amountSat = ref.watch(sendSatsControllerProvider).amountSat;
    final amount = ref.watch(displayBitcoinAmountProvider(amountSat));
    final unit = ref.watch(bitcoinUnitProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(kSpacing1),
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Palette.neutral[100]!,
              ),
              onPressed: () => router.goNamed('pocket'),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/images/payment_send.png',
            width: 160.0,
            height: 160.0,
          ),
          Column(
            children: [
              Text(
                copy.paymentCompleted,
                style: textTheme.display5(
                  Palette.lilac[100],
                  FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                '- $amount ${unit.name.toUpperCase()}',
                style: textTheme.display7(
                  Palette.lilac[100],
                  FontWeight.bold,
                ),
              ),
            ],
          ),
          PrimaryTextButton(
            text: copy.paymentDetails,
            trailingIcon: Icon(
              Icons.arrow_forward_ios,
              color: Palette.russianViolet[100],
              size: 16.0,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
