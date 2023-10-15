import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/widgets/navigation/scaffold_with_nested_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PocketModeScaffoldWithNestedNavigation extends StatelessWidget {
  const PocketModeScaffoldWithNestedNavigation(
      {super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;

    // the UI shell
    return ScaffoldWithNestedNavigation(
      navigationShell: navigationShell,
      destinationIcons: [
        SvgPicture.asset('assets/icons/pocket.svg'),
        SvgPicture.asset('assets/icons/contacts.svg'),
        SvgPicture.asset('assets/icons/gift.svg'),
      ],
      destinationLabels: [
        copy.pocket,
        copy.contacts,
        copy.forYou,
      ],
    );
  }
}
