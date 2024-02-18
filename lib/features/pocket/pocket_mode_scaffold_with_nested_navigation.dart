import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/enums/local_currency.dart';
import 'package:kumuly_pocket/features/pocket/menu/pocket_mode_menu_controller.dart';
import 'package:kumuly_pocket/router/app_router.dart';
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

final GlobalKey<ScaffoldState> pocketModeScaffoldKey =
    GlobalKey<ScaffoldState>();

class PocketModeScaffoldWithNestedNavigation extends ConsumerWidget {
  const PocketModeScaffoldWithNestedNavigation(
      {super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;
    final state = ref.watch(pocketModeMenuControllerProvider).asData?.value;

    // the UI shell
    return ScaffoldWithNestedNavigation(
      scaffoldKey: pocketModeScaffoldKey,
      navigationShell: navigationShell,
      endDrawer: MenuDrawer(
        avatar: const DynamicIcon(
          icon: 'assets/icons/pocket.svg',
          color: Colors.white,
        ),
        alias: InkWell(
          onTap: state != null
              ? () {
                  Clipboard.setData(ClipboardData(text: state.nodeId));
                }
              : null,
          child: state != null
              ? Text(
                  state.partialNodeId,
                  style: Theme.of(context)
                      .textTheme
                      .display2(
                        Palette.neutral[120],
                        FontWeight.normal,
                      )
                      .copyWith(
                        letterSpacing: 0.0,
                      ),
                )
              : const CircularProgressIndicator(),
        ),
        onQrTap: () {
          router.pushNamed(AppRoute.contactId.name);
        },
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
            onTap: () async {
              showTransitionDialog(context, copy.oneMomentPlease);
              await Future.delayed(const Duration(milliseconds: 1500));
              router.goNamed(AppRoute.sales.name);
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
            subtitle:
                '${state != null ? state.notifications.length : 0} ${copy.newNotifications}',
          ),
          const DrawerSectionSpace(),
          DrawerSectionTitle(title: copy.forYou),
          DrawerItem(
            leadingIcon: DynamicIcon(
              icon: 'assets/icons/gift.svg',
              color: Palette.neutral[80],
            ),
            title: copy.yourActivity,
            onTap: () => router.pushNamed(AppRoute.activity.name),
          ),
          const DrawerSectionSpace(),
          DrawerSectionTitle(title: copy.appSettings),
          DrawerItem(
            leadingIcon: DynamicIcon(
              icon: 'assets/icons/bitcoin_b.svg',
              color: Palette.neutral[80],
            ),
            title: copy.bitcoinUnit,
            subtitle: state != null ? state.bitcoinUnit.name.toUpperCase() : '',
            onTap: () {
              router.pushNamed(AppRoute.bitcoinUnit.name);
            },
          ),
          DrawerItem(
            leadingIcon:
                const DynamicIcon(icon: Icons.currency_exchange_outlined),
            title: copy.localCurrency,
            subtitle:
                state != null ? state.localCurrency.code.toUpperCase() : '',
            onTap: () {
              router.pushNamed(AppRoute.localCurrency.name);
            },
          ),
          DrawerItem(
            leadingIcon: const DynamicIcon(icon: Icons.my_location_outlined),
            title: copy.location,
            subtitle: state != null ? state.location : '',
            onTap: () {
              router.pushNamed(AppRoute.location.name);
            },
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
            onTap: () {
              router.pushNamed(AppRoute.seedBackupFlow.name);
            },
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
            title: '${copy.version} ${state != null ? state.version : ''}',
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
