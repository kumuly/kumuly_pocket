import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/local_currency.dart';
import 'package:kumuly_pocket/features/chat/send/chat_send_controller.dart';
import 'package:kumuly_pocket/features/pocket/pocket_balance_controller.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/buttons/rectangular_border_button.dart';
import 'package:kumuly_pocket/widgets/dividers/dashed_divider.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';

class ChatSendBottomSheetModal extends ConsumerWidget {
  const ChatSendBottomSheetModal({required this.contactId, Key? key})
      : super(key: key);

  final String contactId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    // Calculate the keyboard height
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Get the state and notifier for the controller
    final state = ref.watch(chatSendControllerProvider(contactId));
    final notifier = ref.read(chatSendControllerProvider(contactId).notifier);

    final pocketBalance = ref.watch(pocketBalanceControllerProvider).balanceSat;
    final bitcoinUnit = ref.watch(bitcoinUnitProvider);
    final localCurrency = ref.watch(localCurrencyProvider);
    final localCurrencyAmount =
        ref.watch(satToLocalProvider(state.amountSat)).asData?.value ?? 0;

    return GestureDetector(
      onVerticalDragStart: (_) => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: keyboardHeight, // Dynamic padding based on keyboard height
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
            // Your modal content goes here
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: CloseButton(
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
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: kSpacing3,
                        left: kSpacing3,
                      ),
                      child: Text(
                        'Pocket balance: $pocketBalance ${bitcoinUnit.name}'
                            .toUpperCase(),
                        style: textTheme.caption1(
                          Palette.neutral[50],
                          FontWeight.w500,
                        ),
                      ),
                    ),
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
                              'Amount to send',
                              style: textTheme.display2(
                                Palette.neutral[80],
                                FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: kSpacing2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IntrinsicWidth(
                                  child: TextField(
                                    autofocus: true,
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
                                      hintText: '0',
                                      hintStyle: textTheme.display7(
                                        Palette.neutral[40],
                                        FontWeight.w600,
                                      ),
                                    ),
                                    onChanged: notifier.amountChangeHandler,
                                  ),
                                ),
                                const SizedBox(
                                  width: kSpacing1 / 2,
                                ), // Adjust the width value for the desired spacing
                                Text(
                                  bitcoinUnit.name.toUpperCase(),
                                  style: textTheme.display2(
                                    Palette.neutral[70],
                                    FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '≈ ${localCurrencyAmount.toStringAsFixed(localCurrency.decimals)}  ${localCurrency.code.toUpperCase()}',
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
                          hintText: 'Add a note here',
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
                        onChanged: notifier.memoChangeHandler,
                      ),
                    ),
                    RectangularBorderButton(
                      text: 'Send funds',
                      trailingIcon: DynamicIcon(
                        icon: 'assets/icons/send_coins.svg',
                        color: state.amountSat == null || state.amountSat! <= 0
                            ? Palette.neutral[40]
                            : Palette.russianViolet[100],
                        size: 24,
                      ),
                      borderColor: Palette.neutral[30]!,
                      onPressed:
                          state.amountSat == null || state.amountSat! <= 0
                              ? null
                              : notifier.sendHandler,
                    ),
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
