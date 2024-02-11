import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/cashier_flow/generation/cashier_generation_controller.dart';
import 'package:kumuly_pocket/widgets/amounts/bitcoin_amount_display.dart';
import 'package:kumuly_pocket/widgets/amounts/local_currency_amount_display.dart';
import 'package:kumuly_pocket/widgets/buttons/rectangular_border_button.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class CashierAmountScreen extends ConsumerWidget {
  const CashierAmountScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);

    final amountSat = ref.watch(cashierGenerationControllerProvider).amountSat;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Palette.neutral[100]!,
            size: 24.0,
          ),
          onPressed: () {
            router.goNamed('sales');
          },
        ),
        title: Text(
          copy.cashier,
          style: Theme.of(context).textTheme.display4(
                Palette.neutral[100]!,
                FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Palette.neutral[100]!,
        iconTheme: IconThemeData(color: Palette.neutral[100]!),
        actions: [
          IconButton(
            icon: DynamicIcon(
              icon: 'assets/icons/qr_code_scanner_promo.svg',
              color: Palette.neutral[100]!,
              size: 24.0,
            ),
            onPressed: () {
              router.pushNamed('promo-validation-flow');
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  copy.enterAnAmount,
                  style:
                      textTheme.display3(Palette.neutral[70], FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: kSpacing2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IntrinsicWidth(
                            child: TextField(
                              autofocus: true,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              textAlign: TextAlign.center,
                              style: textTheme.display7(
                                  Palette.neutral[100], FontWeight.w600),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '0',
                                hintStyle: textTheme.display7(
                                    Palette.neutral[60], FontWeight.w600),
                              ),
                              onChanged: ref
                                  .read(cashierGenerationControllerProvider
                                      .notifier)
                                  .amountChangeHandler,
                            ),
                          ),
                          const SizedBox(
                            width: kSpacing1 / 2,
                          ),
                          LocalCurrencyAmountDisplay(
                            amountSat: amountSat,
                            amountStyle: textTheme.display3(
                              Palette.neutral[80],
                              FontWeight.w400,
                            ),
                          ) // Adjust the width value for the desired spacing
                        ],
                      ),
                      BitcoinAmountDisplay(
                        prefix: '≈ ',
                        amountSat: amountSat,
                        amountStyle: textTheme.display1(
                          Palette.neutral[50],
                          FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          RectangularBorderButton(
            text: copy.confirmAmount,
            onPressed: amountSat == null || amountSat == 0
                ? null
                : () async {
                    try {
                      final fetchingInvoice = ref
                          .read(cashierGenerationControllerProvider.notifier)
                          .createInvoice();

                      // Show loading screen
                      showTransitionDialog(context, copy.oneMomentPlease);

                      // Unfocus to hide the keyboard from inputting the amount
                      FocusScope.of(context).unfocus();

                      // Wait for the invoice to be fetched
                      await fetchingInvoice;

                      // Pop  the transition dialog
                      router.pop();
                      ref
                          .read(pageViewControllerProvider(
                            kCashierFlowPageViewId,
                          ).notifier)
                          .nextPage();
                      return;
                    } catch (e) {
                      print(e);
                      // Set an error message to the state and show it
                      // Pop  the transition dialog
                      router.pop();
                    }
                  },
          ),
        ],
      ),
    );
  }
}
