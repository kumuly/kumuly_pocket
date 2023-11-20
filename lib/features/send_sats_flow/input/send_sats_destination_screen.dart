import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/payment_request_type.dart';
import 'package:kumuly_pocket/features/send_sats_flow/send_sats_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/buttons/rectangular_border_button.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';

class SendSatsDestinationScreen extends ConsumerWidget {
  const SendSatsDestinationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);

    final state = ref.watch(sendSatsControllerProvider);
    print('SendSatsDestinationScreen build(): $state');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          copy.sendBitcoin,
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing3),
              child: Text(
                copy.sendToOtherBitcoinSpendingOrSavingsWallet,
                style: Theme.of(context).textTheme.display2(
                      Palette.neutral[60]!,
                      FontWeight.w400,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(kSpacing3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('${copy.destination}:',
                        style: textTheme.display3(
                          Palette.neutral[70],
                          FontWeight.w500,
                        )),
                    const SizedBox(height: 8), // Adjust for desired spacing
                    TextField(
                      focusNode: state.destinationFocusNode,
                      controller: state.destinationTextController,
                      textAlignVertical: TextAlignVertical.center,
                      style: textTheme.display3(
                        Palette.neutral[70],
                        FontWeight.w400,
                      ),
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Palette.neutral[20]!,
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.only(
                          left: 12.0,
                          right: 31.0,
                          top: 11.0,
                          bottom: 11.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: copy.bitcoinAddressOrLightningCode,
                        hintStyle: textTheme.display2(
                          Palette.neutral[60],
                          FontWeight.w400,
                        ),
                      ),
                      onChanged: ref
                          .read(sendSatsControllerProvider.notifier)
                          .onDestinationChangeHandler,
                    ),
                    state.destinationInputError != null
                        ? const SizedBox(height: kSpacing1)
                        : Container(),
                    state.destinationInputError != null
                        ? Text(
                            copy.pleaseProvideAValidBitcoinAddressOrLightningCode,
                            style: textTheme.display1(
                              Palette.error[100]!,
                              FontWeight.w500,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(kSpacing3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      copy.scanOrUploadBitcoinQrCode,
                      style: textTheme.display3(
                        Palette.neutral[70],
                        FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: kSpacing2,
                    ),
                    IconButton.filledTonal(
                      padding: const EdgeInsets.all(kSpacing2),
                      iconSize: 24,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.transparent,
                        ),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(
                              color: Palette.neutral[30]!,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        router.pushNamed('send-sats-scanner');
                      },
                      icon: DynamicIcon(
                        icon: 'assets/icons/qr_code_scanner.svg',
                        color: Palette.neutral[80],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            RectangularBorderButton(
              text: copy.confirmDestination,
              onPressed: !state.isValidDestination
                  ? null
                  : () async {
                      // Check for errors and if no errors, go to next page
                      if (state.paymentRequestType ==
                              PaymentRequestType.bolt11 &&
                          state.invoice?.secondsTillExpiry == 0) {
                        router.pushNamed('expired-invoice');
                      } else {
                        ref
                            .read(pageViewControllerProvider(
                                    kSendSatsFlowPageViewId)
                                .notifier)
                            .nextPage();
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
