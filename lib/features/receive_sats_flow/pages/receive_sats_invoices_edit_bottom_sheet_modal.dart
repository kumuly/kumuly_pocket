import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/receive_sats_controller.dart';

import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/widgets/dividers/dashed_divider.dart';
import 'package:kumuly_pocket/widgets/loaders/label_with_loading_animation.dart';

class ReceiveSatsInvoicesEditBottomSheetModal extends ConsumerWidget {
  const ReceiveSatsInvoicesEditBottomSheetModal({
    super.key,
  });

  get textTheme => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;

    final state = ref.watch(receiveSatsControllerProvider);
    final notifier = ref.read(receiveSatsControllerProvider.notifier);

    return state.isFetchingEditedInvoice
        ? Center(
            heightFactor: 5,
            child: LabelWithLoadingAnimation(
              '${copy.updatingInvoice}...',
            ),
          )
        : GestureDetector(
            onVerticalDragStart: (_) => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context)
                      .viewInsets
                      .bottom, // Dynamic padding based on keyboard height
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.8),
                        Colors.white,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    border: Border.all(color: Palette.neutral[40]!, width: 1),
                  ),
                  // Modal content
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CloseButton(
                            style: ButtonStyle(
                              iconSize: MaterialStateProperty.all(kSpacing2),
                              iconColor: MaterialStateProperty.all(
                                Palette.neutral[70],
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.all(kSpacing1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 53),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: kSpacing3,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    copy.hoursTillExpiry,
                                    style: textTheme.display2(
                                      Palette.neutral[80],
                                      FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: kSpacing2),
                                  TextField(
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    style: textTheme.display7(
                                      Palette.neutral[120],
                                      FontWeight.w600,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      hintText: '1',
                                      hintStyle: textTheme.display7(
                                        Palette.neutral[40],
                                        FontWeight.w600,
                                      ),
                                    ),
                                    controller: state.hoursTillExpiryController,
                                    onChanged:
                                        notifier.hoursTillExpiryChangeHandler,
                                  ),
                                  Text(
                                    '≈ ${state.formattedExpiry}',
                                    style: textTheme.display1(
                                      Palette.neutral[60],
                                      FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: kSpacing9,
                          ),
                          Center(
                            child: DashedDivider(
                              length: MediaQuery.of(context).size.width,
                            ),
                          ),
                          SizedBox(
                            height: kSpacing17,
                            child: TextField(
                              maxLines: 3,
                              autofocus: true,
                              keyboardType: TextInputType.text,
                              style: textTheme.body3(
                                Palette.neutral[70],
                                FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: copy.addNoteToPayer,
                                hintStyle: textTheme.body3(
                                  Palette.neutral[50],
                                  FontWeight.w400,
                                ),
                                contentPadding: const EdgeInsets.fromLTRB(
                                  kSpacing3,
                                  kSpacing2,
                                  kSpacing3,
                                  kSpacing5,
                                ),
                              ),
                              controller: state.descriptionController,
                            ),
                          ),
                          const ReceiveSatsFeeBottomSheetModalGenerateInvoiceButton(),
                          const SizedBox(height: kSpacing5),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class ReceiveSatsFeeBottomSheetModalGenerateInvoiceButton
    extends ConsumerWidget {
  const ReceiveSatsFeeBottomSheetModalGenerateInvoiceButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;
    final notifier = ref.read(receiveSatsControllerProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        PrimaryFilledButton(
          text: copy.updateInvoice,
          fillColor: Palette.neutral[120],
          textColor: Colors.white,
          onPressed: () async {
            try {
              final invoiceEditing = notifier.editInvoice();
              // Remove the keyboard from inputting
              FocusScope.of(context).unfocus();
              // Wait for the invoice to be created
              await invoiceEditing;
              // Pop one time for the bottom sheet
              router.pop();
            } catch (e) {
              print(e);
            }
          },
          trailingIcon: const Icon(
            Icons.qr_code,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
