import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/payment_request_type.dart';
import 'package:kumuly_pocket/features/send_sats_flow/send_sats_controller.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/widgets/cards/title_value_card.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class SendSatsOverviewScreen extends ConsumerWidget {
  const SendSatsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);

    final state = ref.watch(sendSatsControllerProvider);
    final amount = ref.watch(displayBitcoinAmountProvider(state.amountSat));
    final unit = ref.watch(bitcoinUnitProvider);
    final pageController = ref.read(pageViewControllerProvider(
      kSendSatsFlowPageViewId,
    ).notifier);

    return Scaffold(
      backgroundColor: Palette.neutral[10]!,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            pageController.previousPage();
          },
        ),
        title: Text(
          copy.paymentDetails,
          style: textTheme.display4(
            Palette.neutral[100]!,
            FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Palette.neutral[100]!,
        iconTheme: IconThemeData(color: Palette.neutral[100]!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TitleValueCard(
              title: copy.amountToSend,
              valueWidget: RichText(
                text: TextSpan(
                  text: amount,
                  style: textTheme.display7(
                    Palette.neutral[80],
                    FontWeight.w800,
                  ),
                  children: [
                    TextSpan(
                      text: ' ${unit.name.toUpperCase()}',
                      style: textTheme.display7(
                        Palette.neutral[80],
                        FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: kSpacing2), // spacing between cards
            TitleValueCard(
              title: copy.operationFees,
              value: '+ 0 ${unit.name.toUpperCase()}', // Todo: Calculate this
              extraInfo: [
                PaymentRequestType.bitcoinAddress,
                PaymentRequestType.bip21
              ].contains(state.paymentRequestType)
                  ? '${copy.processingTime} ~ ${copy.bitcoinProcessingTime}'
                  : '${copy.processingTime} ~ ${copy.lightningProcessingTime}',
            ),
            const SizedBox(height: kSpacing2), // spacing between cards
            TitleValueCard(
              title:
                  '${copy.destination} ・ ${state.paymentRequestType == PaymentRequestType.bitcoinAddress ? copy.bitcoinAddress : state.paymentRequestType == PaymentRequestType.bolt11 ? copy.lightningInvoice : state.paymentRequestType == PaymentRequestType.bip21 ? copy.bitcoinAddress : state.paymentRequestType == PaymentRequestType.nodeId ? copy.lightningNode : copy.lnurlPay}',
              value:
                  state.paymentRequestType == PaymentRequestType.bitcoinAddress
                      ? state.partialBitcoinAddress
                      : state.paymentRequestType == PaymentRequestType.bolt11
                          ? state.invoice?.partialBolt11
                          : state.paymentRequestType == PaymentRequestType.bip21
                              ? state.bip21?.partialBitcoinAddress
                              : state.paymentRequestType ==
                                      PaymentRequestType.nodeId
                                  ? state.partialNodeId
                                  : state.lnurlPay?.partialLnurl,
              extraInfo: state.paymentRequestType == PaymentRequestType.bolt11
                  ? '${copy.thisCodeExpiresIn} ${state.invoice?.displayTimeTillExpiry(
                      copy.seconds,
                      copy.minutes,
                      copy.hours,
                      copy.days,
                      copy.months,
                    )} '
                  : null,
              trailingImageName: [
                PaymentRequestType.bitcoinAddress,
                PaymentRequestType.bip21
              ].contains(state.paymentRequestType)
                  ? 'assets/icons/btc_avatar.png'
                  : 'assets/icons/lightning_avatar.png',
            ),
            const SizedBox(height: kSpacing3),
            PrimaryFilledButton(
              textColor: Colors.white,
              fillColor: Palette.russianViolet[100]!,
              text: copy.confirmAndSend,
              onPressed: () async {
                try {
                  final sendingPayment = ref
                      .read(sendSatsControllerProvider.notifier)
                      .sendPayment();
                  showTransitionDialog(context, copy.oneMomentPlease);

                  await sendingPayment;
                  router.pop(); // Close the dialog
                  pageController.nextPage();
                } catch (e) {
                  print(e);
                  // Todo: Handle and set error
                  router.pop(); // Close the dialog
                }
              },
              trailingIcon: const Icon(Icons.send_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
