import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/bitcoin_unit.dart';
import 'package:kumuly_pocket/enums/local_currency.dart';
import 'package:kumuly_pocket/features/sales/sales_controller.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/buttons/focus_mark_icon_button.dart';
import 'package:kumuly_pocket/widgets/headers/wallet_header.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/lists/transaction_list.dart';
import 'package:kumuly_pocket/widgets/modals/actions_bottom_sheet_modal.dart';
import 'package:kumuly_pocket/widgets/navigation/merchant_mode_scaffold_with_nested_navigation.dart';
import 'package:kumuly_pocket/widgets/shadows/bottom_shadow.dart';

class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    double screenWidth = MediaQuery.of(context).size.width;

    final salesController = ref.watch(salesControllerProvider);
    const unit = BitcoinUnit.sat;
    const fiatCurrency = LocalCurrency.usd;
    final balance = unit == BitcoinUnit.btc
        ? salesController.balanceInBtc
        : salesController.balanceInSat;
    const balanceInFiat = 0;

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
              onPressed: merchantModeScaffoldKey.currentState!.openEndDrawer,
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: kExtraLargeSpacing),
              WalletHeader(
                title: copy.totalSales.toUpperCase(),
                balance: balance,
                unit: unit,
                balanceInFiat: balanceInFiat,
                fiatCurrency: fiatCurrency,
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
                              icon: 'assets/icons/pocket.svg',
                              color: Palette.neutral[80]!,
                            ),
                          ],
                          actionTitles: [
                            copy.moveToPocket,
                          ],
                          actionOnPresseds: [
                            () {},
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: kExtraLargeSpacing,
              ),
              TransactionList(
                title: copy.recentTransactions.toUpperCase(),
              ),
            ],
          ),
        ),
        BottomShadow(
          width: screenWidth,
        ),
      ]),
    );
  }
}
