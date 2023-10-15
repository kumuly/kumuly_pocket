import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/drawer/drawer_item.dart';
import 'package:kumuly_pocket/widgets/drawer/drawer_logout_item.dart';
import 'package:kumuly_pocket/widgets/drawer/drawer_section_space.dart';
import 'package:kumuly_pocket/widgets/drawer/drawer_section_title.dart';
import 'package:kumuly_pocket/widgets/drawer/menu_drawer.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/navigation/scaffold_with_nested_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final GlobalKey<ScaffoldState> pocketModeScaffoldKey =
    GlobalKey<ScaffoldState>();

class PocketModeScaffoldWithNestedNavigation extends StatelessWidget {
  const PocketModeScaffoldWithNestedNavigation(
      {super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    const alias = 'Kathryn Nakamoto';
    const nrOfNotifications = 3;
    const bitcoinUnit = 'SAT';
    const localCurrency = 'EUR';
    const myLocation = 'Leuven, BE';
    const version = '0.0.0';

    // the UI shell
    return ScaffoldWithNestedNavigation(
      scaffoldKey: pocketModeScaffoldKey,
      navigationShell: navigationShell,
      endDrawer: MenuDrawer(
        alias: alias,
        children: [
          const DrawerSectionSpace(),
          DrawerItem(
            leadingIcon: DynamicIcon(
              icon: Icons.storefront_outlined,
              color: Palette.neutral[80],
            ),
            title: copy.switchToMerchantMode,
            trailingIcon: DynamicIcon(
              icon: 'assets/icons/switch.svg',
              color: Palette.neutral[80],
            ),
            onTap: () => context.goNamed('sales'),
          ),
          const DrawerSectionSpace(),
          Divider(
            color: Palette.neutral[30],
          ),
          const DrawerSectionSpace(),
          DrawerItem(
            leadingIcon: DynamicIcon(
              icon: Icons.notifications_outlined,
              color: Palette.neutral[80],
            ),
            title: copy.notifications,
            subtitle: '$nrOfNotifications ${copy.newNotifications}',
          ),
          const DrawerSectionSpace(),
          DrawerSectionTitle(title: copy.yourActivity),
          DrawerItem(
            leadingIcon: DynamicIcon(
              icon: 'assets/icons/gift.svg',
              color: Palette.neutral[80],
            ),
            title: copy.promos,
          ),
          const DrawerSectionSpace(),
          DrawerSectionTitle(title: copy.appSettings),
          DrawerItem(
            leadingIcon: DynamicIcon(
              icon: 'assets/icons/bitcoin_b.svg',
              color: Palette.neutral[80],
            ),
            title: copy.bitcoinUnit,
            subtitle: bitcoinUnit,
          ),
          DrawerItem(
            leadingIcon:
                const DynamicIcon(icon: Icons.currency_exchange_outlined),
            title: copy.localCurrency,
            subtitle: localCurrency,
          ),
          DrawerItem(
            leadingIcon: const DynamicIcon(icon: Icons.my_location_outlined),
            title: copy.location,
            subtitle: myLocation,
          ),
          const DrawerSectionSpace(),
          DrawerSectionTitle(title: copy.security),
          DrawerItem(
            leadingIcon: DynamicIcon(
              icon: Icons.dialpad_rounded,
              color: Palette.neutral[80],
            ),
            title: copy.changePIN,
          ),
          DrawerItem(
            leadingIcon: DynamicIcon(
              icon: 'assets/icons/seed.svg',
              color: Palette.neutral[80],
            ),
            title: copy.seedWords,
          ),
          const DrawerSectionSpace(),
          DrawerSectionTitle(title: copy.kumulyPocketApp),
          DrawerItem(
            leadingIcon: DynamicIcon(
              icon: 'assets/icons/acorn.svg',
              color: Palette.neutral[80],
            ),
            title: copy.aboutKumuly,
          ),
          DrawerItem(
            leadingIcon: DynamicIcon(
              icon: Icons.help_outline_outlined,
              color: Palette.neutral[80],
            ),
            title: copy.faq,
          ),
          DrawerItem(
            leadingIcon: DynamicIcon(
              icon: Icons.support_agent_outlined,
              color: Palette.neutral[80],
            ),
            title: copy.techSupport,
          ),
          const DrawerSectionSpace(),
          DrawerSectionTitle(title: copy.others),
          DrawerItem(
            title: copy.termsAndConditions,
          ),
          DrawerItem(
            title: copy.privacyPolicy,
          ),
          DrawerItem(
            title: copy.fees,
          ),
          DrawerItem(
            title: '${copy.version} $version',
            titleTextStyle: Theme.of(context).textTheme.display1(
                  Palette.neutral[60],
                  FontWeight.w500,
                ),
            trailingIcon: DynamicIcon(
              icon: null,
              color: Palette.neutral[80],
            ),
          ),
          const DrawerSectionSpace(),
          const DrawerLogoutItem(),
          const DrawerSectionSpace(),
        ],
      ),
      destinationIcons: const [
        'assets/icons/pocket.svg',
        'assets/icons/contacts.svg',
        'assets/icons/gift.svg',
      ],
      destinationSelectedIcons: const [
        'assets/icons/pocket.svg',
        'assets/icons/contacts.svg',
        'assets/icons/gift.svg',
      ],
      destinationLabels: [
        copy.pocket,
        copy.contacts,
        copy.forYou,
      ],
    );
  }
}
