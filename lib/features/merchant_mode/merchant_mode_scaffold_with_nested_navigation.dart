import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:kumuly_pocket/widgets/drawer/drawer_item.dart';
import 'package:kumuly_pocket/widgets/drawer/drawer_logout_item.dart';
import 'package:kumuly_pocket/widgets/drawer/drawer_section_space.dart';
import 'package:kumuly_pocket/widgets/drawer/drawer_section_title.dart';
import 'package:kumuly_pocket/widgets/drawer/menu_drawer.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/navigation/scaffold_with_nested_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final GlobalKey<ScaffoldState> merchantModeScaffoldKey =
    GlobalKey<ScaffoldState>();

class MerchantModeScaffoldWithNestedNavigation extends StatelessWidget {
  const MerchantModeScaffoldWithNestedNavigation(
      {super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;
    const merchantName = 'A company name here';
    const nrOfNotifications = 3;
    const version = '0.0.0';

    // the UI shell
    return ScaffoldWithNestedNavigation(
      scaffoldKey: merchantModeScaffoldKey,
      navigationShell: navigationShell,
      endDrawer: MenuDrawer(
        alias: merchantName,
        avatarAssetName: 'assets/images/dummy_merchant_avatar.png',
        children: [
          const DrawerSectionSpace(),
          DrawerItem(
            leadingIcon: DynamicIcon(
              icon: 'assets/icons/pocket.svg',
              color: Palette.neutral[80],
            ),
            title: copy.switchToPocketMode,
            trailingIcon: DynamicIcon(
              icon: 'assets/icons/switch.svg',
              color: Palette.neutral[80],
            ),
            onTap: () async {
              showTransitionDialog(context, copy.oneMomentPlease);
              await Future.delayed(const Duration(milliseconds: 1500));
              router.goNamed('pocket');
            },
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
        Icons.storefront_outlined,
        Icons.point_of_sale_outlined,
        'assets/icons/posts.svg',
      ],
      destinationSelectedIcons: const [
        Icons.storefront,
        Icons.point_of_sale,
        'assets/icons/posts.svg',
      ],
      destinationLabels: [
        copy.salesRegister,
        copy.cashier,
        copy.myPosts,
      ],
    );
  }
}
