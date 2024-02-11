import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/cashier_flow/generation/cashier_generation_controller.dart';
import 'package:kumuly_pocket/features/cashier_flow/reception/cashier_reception_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/amounts/bitcoin_amount_display.dart';
import 'package:kumuly_pocket/widgets/amounts/local_currency_amount_display.dart';
import 'package:kumuly_pocket/widgets/containers/ripped_paper_container.dart';
import 'package:kumuly_pocket/widgets/dividers/dashed_divider.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CashierReceptionScreen extends ConsumerWidget {
  const CashierReceptionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;

    // Start listening for the payment through the controller
    ref.watch(cashierReceptionControllerProvider);

    final generationState = ref.watch(cashierGenerationControllerProvider);

    final invoice = generationState.invoice;
    final partialInvoice = generationState.partialInvoice;
    final amountSat = generationState.amountSat;

    return Scaffold(
      backgroundColor: Palette.neutral[30],
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
                  .read(pageViewControllerProvider(
                    kCashierFlowPageViewId,
                  ).notifier)
                  .previousPage();
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          RippedPaperContainer(
            width: 264,
            child: Column(
              children: [
                invoice == null
                    ? const Text('Something went wrong.')
                    : QrImageView(
                        data: invoice.bolt11,
                        size: 200,
                        embeddedImage: Image.asset(
                          'assets/images/dummy_merchant_avatar.png',
                        ).image,
                        embeddedImageStyle: const QrEmbeddedImageStyle(
                          size: Size(32, 32),
                        ),
                      ),
                const SizedBox(height: kSpacing1 * 1.5),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: invoice!.bolt11))
                        .then(
                      (_) {
                        // Optionally, show a confirmation message to the user.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(copy.invoiceCopied),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        partialInvoice,
                        style: textTheme.display1(
                            Palette.neutral[80], FontWeight.w400),
                      ),
                      Text(
                        copy.copy,
                        style: textTheme.display1(
                            Palette.lilac[100], FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kSpacing4),
                DashedDivider(
                  color: Palette.neutral[40]!,
                  length: 264,
                ),
                const SizedBox(height: kSpacing4),
                LocalCurrencyAmountDisplay(
                  amountSat: amountSat,
                  amountStyle: textTheme.display8(
                    Palette.neutral[120],
                    FontWeight.w400,
                  ),
                  unitCodeStyle: textTheme.display6(
                    Palette.neutral[120],
                    FontWeight.w400,
                  ),
                ),
                const SizedBox(height: kSpacing1 / 2),
                BitcoinAmountDisplay(
                  prefix: '≈ ',
                  amountSat: amountSat,
                  amountStyle: textTheme.display1(
                    Palette.neutral[60],
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kSpacing6),
            child: Text(
              copy.cashierPaymentInstructions,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.body3(
                    Palette.neutral[80]!,
                    FontWeight.w400,
                  ),
            ),
          ),
          const SizedBox(height: kSpacing10),
        ],
      ),
    );
  }
}
