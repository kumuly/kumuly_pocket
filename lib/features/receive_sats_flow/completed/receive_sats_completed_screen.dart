import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/generation/receive_sats_generation_controller.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/reception/receive_sats_reception_controller.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';

class ReceiveSatsCompletedScreen extends ConsumerWidget {
  const ReceiveSatsCompletedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);
    final generationProvider =
        ref.watch(receiveSatsGenerationControllerProvider);
    final receptionProvider = ref.watch(receiveSatsReceptionControllerProvider);

    final amountSat = generationProvider.amountSat;
    final isPaid = receptionProvider.isPaid;
    final amount = ref.watch(displayBitcoinAmountProvider(amountSat));
    final unit = ref.watch(bitcoinUnitProvider);

    return Scaffold(
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
            isPaid
                ? 'assets/images/payment_received.png'
                : 'assets/images/payment_pending.png',
            width: 160.0,
            height: 160.0,
          ),
          Column(
            children: [
              Text(
                isPaid ? copy.paymentCompleted : copy.paymentInProcess,
                style: textTheme.display5(
                  Palette.success[50],
                  FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                '+ $amount ${unit.name.toUpperCase()}',
                style: textTheme.display7(
                  isPaid ? Palette.success[50] : Palette.neutral[60],
                  FontWeight.w700,
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
