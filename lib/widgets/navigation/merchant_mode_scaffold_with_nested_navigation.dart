import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/widgets/navigation/scaffold_with_nested_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MerchantModeScaffoldWithNestedNavigation extends StatelessWidget {
  const MerchantModeScaffoldWithNestedNavigation(
      {super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;

    // the UI shell
    return ScaffoldWithNestedNavigation(
      navigationShell: navigationShell,
      destinationIcons: const [
        Icons.store_outlined,
        Icons.point_of_sale_outlined,
        Icons.discount_outlined,
      ],
      destinationLabels: [
        copy.salesRegister,
        copy.cashier,
        copy.myPosts,
      ],
    );
  }
}
