import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/sales/sales_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';
import 'package:kumuly_pocket/widgets/headers/wallet_header.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/lists/sales_list.dart';
import 'package:kumuly_pocket/features/merchant_mode/merchant_mode_scaffold_with_nested_navigation.dart';
import 'package:kumuly_pocket/widgets/shadows/bottom_shadow.dart';

class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;

    final state = ref.watch(salesControllerProvider);

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
              const SizedBox(height: kSpacing12),
              WalletHeader(
                title: copy.totalSales.toUpperCase(),
                balanceSat: state.balanceSat,
                actions: [
                  PrimaryTextButton(
                    text: copy.moveFundsToPocket,
                    textStyle: textTheme.body3(
                      Palette.russianViolet[100],
                      FontWeight.w700,
                      wordSpacing: 0,
                    ),
                    trailingIcon: Icon(
                      Icons.arrow_forward_ios,
                      color: Palette.russianViolet[100],
                      size: 12.0,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(
                height: kSpacing4,
              ),
              const SalesGraph(),
              const SizedBox(
                height: kSpacing3,
              ),
              SalesList(
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

class SalesGraph extends StatelessWidget {
  const SalesGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Palette.neutral[30]!),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        child: Image.asset('assets/images/mock_sales_graph.png'),
      ),
    );
  }
}
