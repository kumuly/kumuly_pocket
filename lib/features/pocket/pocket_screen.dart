import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/pocket/pocket_balance_controller.dart';
import 'package:kumuly_pocket/features/pocket/pocket_payments_history_controller.dart';
import 'package:kumuly_pocket/providers/currency_conversion_providers.dart';
import 'package:kumuly_pocket/providers/settings_providers.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/buttons/focus_mark_icon_button.dart';
import 'package:kumuly_pocket/widgets/headers/wallet_header.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/lists/payment_history.dart';
import 'package:kumuly_pocket/widgets/modals/actions_bottom_sheet_modal.dart';
import 'package:kumuly_pocket/features/pocket_mode/pocket_mode_scaffold_with_nested_navigation.dart';
import 'package:kumuly_pocket/widgets/shadows/bottom_shadow.dart';

class PocketScreen extends ConsumerWidget {
  const PocketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    double screenWidth = MediaQuery.of(context).size.width;
    final router = GoRouter.of(context);

    final state = ref.watch(pocketBalanceControllerProvider);

    final historyState = ref.watch(
      pocketPaymentsHistoryControllerProvider(
        kPaymentsLimit,
      ),
    );

    final unit = ref.watch(bitcoinUnitProvider);
    final balance = ref.watch(
      displayBitcoinAmountProvider(
        state.balanceSat,
      ),
    );
    final localCurrency = ref.watch(localCurrencyProvider);
    final localCurrencyBalance =
        ref.watch(satToLocalProvider(state.balanceSat)).asData?.value;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: DynamicIcon(
                icon: Icons.menu_outlined,
                color: Palette.neutral[120]!,
              ),
              onPressed: pocketModeScaffoldKey.currentState!.openEndDrawer,
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(fiatRatesProvider);
              await ref
                  .read(pocketBalanceControllerProvider.notifier)
                  .refreshBalance();
              await ref
                  .read(
                    pocketPaymentsHistoryControllerProvider(kPaymentsLimit)
                        .notifier,
                  )
                  .fetchPayments(refresh: true);
            },
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: kSpacing12),
                WalletHeader(
                  title: copy.pocketBalance.toUpperCase(),
                  balance: balance,
                  unit: unit,
                  localCurrencyBalance: localCurrencyBalance,
                  localCurrency: localCurrency,
                  actions: [
                    FocusMarkIconButton(
                      size: 44,
                      focusCornerLength: 10,
                      focusRadius: 10,
                      focusStrokeWidth: 2.0,
                      focusColor: Palette.neutral[120]!,
                      icon: const DynamicIcon(
                        icon: 'assets/icons/send_receive_arrows.svg',
                      ),
                      iconSize: 24.0,
                      iconColor: Palette.neutral[120]!,
                      onPressed: () {
                        showModalBottomSheet(
                          useRootNavigator: true,
                          elevation: 0,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (context) => ActionsBottomSheetModal(
                            actionIcons: [
                              DynamicIcon(
                                icon: 'assets/icons/scanner.svg',
                                color: Palette.neutral[80]!,
                              ),
                              DynamicIcon(
                                icon: 'assets/icons/receive_arrow.svg',
                                color: Palette.neutral[80]!,
                              ),
                              DynamicIcon(
                                icon: 'assets/icons/send_arrow.svg',
                                color: Palette.neutral[80]!,
                              ),
                              DynamicIcon(
                                icon: 'assets/icons/coin_addition.svg',
                                color: Palette.neutral[80]!,
                              ),
                              DynamicIcon(
                                icon: 'assets/icons/safe_outlined.svg',
                                color: Palette.neutral[80]!,
                              ),
                            ],
                            actionTitles: [
                              copy.scan,
                              copy.receive,
                              copy.send,
                              copy.buyBitcoin,
                              copy.saveInBitcoin,
                            ],
                            actionOnPresseds: [
                              () {},
                              () {
                                router.pop(); // Close bottom sheet
                                router.pushNamed('receive-sats-flow');
                              },
                              () {
                                router.pop(); // Close bottom sheet
                                router.pushNamed('send-sats-flow');
                              },
                              () {},
                              () {},
                              null,
                              null,
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: kSpacing12,
                ),
                PaymentHistory(
                  title: copy.recentTransactions.toUpperCase(),
                  payments: historyState.hasValue
                      ? historyState.asData!.value.payments
                      : [],
                  loadPayments: ref
                      .read(
                        pocketPaymentsHistoryControllerProvider(kPaymentsLimit)
                            .notifier,
                      )
                      .fetchPayments,
                  limit: historyState.hasValue
                      ? historyState.asData!.value.paymentsLimit
                      : kPaymentsLimit,
                  hasMore: historyState.hasValue
                      ? historyState.asData!.value.hasMorePayments
                      : true,
                  isLoading: historyState.isLoading,
                  isLoadingError: historyState.hasError,
                ),
                const SizedBox(
                  height: kSpacing3,
                ),
              ],
            ),
          ),
          BottomShadow(
            width: screenWidth,
          ),
        ],
      ),
    );
  }
}
