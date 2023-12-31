import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/generation/receive_sats_generation_controller.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/reception/receive_sats_reception_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReceiveSatsReceptionScreen extends ConsumerWidget {
  const ReceiveSatsReceptionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    // Watch the controller to start listening for the payment
    ref.watch(receiveSatsReceptionControllerProvider);

    final generationState = ref.watch(receiveSatsGenerationControllerProvider);
    final bip21Uri = generationState.bip21Uri;

    final copy = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Palette.neutral[20],
      appBar: AppBar(
        title: Text(
          copy.receiveBitcoin,
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(kSpacing4, 0, kSpacing4, kSpacing4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                copy.copyCodeOrScanQR,
                style: textTheme.display2(Palette.neutral[70], FontWeight.w400),
              ),
              const SizedBox(height: kSpacing6),
              Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 24),
                      spreadRadius: -12,
                      blurRadius: 48,
                      color: Color.fromRGBO(154, 170, 207, 0.55),
                    ),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kSpacing3),
                  ),
                  color: Colors.white,
                  elevation: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(kSpacing3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            generationState.onChainAddress == null ||
                                    generationState.onChainAddress!.isEmpty ||
                                    generationState.amountSat! >
                                        generationState.onChainMaxAmount! ||
                                    generationState.amountSat! <
                                        generationState.onChainMinAmount!
                                ? Column(
                                    children: [
                                      generationState.onChainAddress == null ||
                                              generationState
                                                  .onChainAddress!.isEmpty
                                          ? Text(
                                              copy.somethingWentWrong,
                                              style: textTheme.display2(
                                                Palette.neutral[40],
                                                FontWeight.w400,
                                              ),
                                              textAlign: TextAlign.center,
                                            )
                                          : generationState.amountSat! >
                                                  generationState
                                                      .onChainMaxAmount!
                                              ? Text(
                                                  copy.amountTooBigForOnChain,
                                                  style: textTheme.display2(
                                                    Palette.neutral[40],
                                                    FontWeight.w400,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                              : Text(
                                                  copy.amountTooSmallForOnChain,
                                                  style: textTheme.display2(
                                                    Palette.neutral[40],
                                                    FontWeight.w400,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                      Text(
                                        copy.bitcoinAddress,
                                        style: textTheme.display2(
                                          Palette.neutral[40],
                                          FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )
                                : InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                              text: generationState
                                                  .onChainAddress!))
                                          .then(
                                        (_) {
                                          // Optionally, show a confirmation message to the user.
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                copy.bitcoinAddressCopied,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          generationState
                                              .partialOnChainAddress!,
                                          style: textTheme.display2(
                                            Palette.neutral[40],
                                            FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          copy.copyBitcoinAddress,
                                          style: textTheme.display2(
                                            Palette.lilac[100],
                                            FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Palette.neutral[20],
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(kSpacing3),
                        child: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                    text: generationState.invoice!.bolt11))
                                .then(
                              (_) {
                                // Optionally, show a confirmation message to the user.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(copy.lightningInvoiceCopied),
                                  ),
                                );
                              },
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                generationState.partialInvoice!,
                                style: textTheme.display2(
                                  Palette.neutral[40],
                                  FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                copy.copyLightningInvoice,
                                style: textTheme.display2(
                                  Palette.lilac[100],
                                  FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Palette.neutral[20],
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: kSpacing3, left: kSpacing5, right: kSpacing5),
                        child: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                    text: generationState.bip21Uri!))
                                .then(
                              (_) {
                                // Optionally, show a confirmation message to the user.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(copy.paymentRequestCopied),
                                  ),
                                );
                              },
                            );
                          },
                          child: QrImageView(data: bip21Uri!),
                        ),
                      ),
                      const SizedBox(height: kSpacing3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: DynamicIcon(
                              icon: 'assets/icons/save_qr_code.svg',
                              color: Palette.neutral[70],
                            ),
                            onPressed: () {},
                          ),
                          const SizedBox(
                            width: kSpacing4,
                          ),
                          Container(
                            height: 24,
                            width: 1,
                            color: Palette.neutral[40],
                          ),
                          const SizedBox(
                            width: kSpacing4,
                          ),
                          IconButton(
                            icon: DynamicIcon(
                              icon: 'assets/icons/share.svg',
                              color: Palette.neutral[70],
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: kSpacing4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
