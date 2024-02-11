import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/features/contacts/contacts_screen.dart';
import 'package:kumuly_pocket/features/for_you/for_you_screen.dart';
import 'package:kumuly_pocket/features/pocket/pocket_screen.dart';
import 'package:kumuly_pocket/features/pocket/pocket_mode_scaffold_with_nested_navigation.dart';

// Private navigators
final _shellNavigatorPocketKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellPocket');
final _shellNavigatorContactsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellContacts');
final _shellNavigatorForYouKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellForYou');

final pocketModeRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return PocketModeScaffoldWithNestedNavigation(
      navigationShell: navigationShell,
    );
  },
  branches: [
    // first branch (Pocket)
    StatefulShellBranch(
      navigatorKey: _shellNavigatorPocketKey,
      routes: [
        // top route inside branch
        GoRoute(
          path: '/pocket',
          name: 'pocket',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: PocketScreen(),
          ),
          routes: const [
            // child route
          ],
        ),
      ],
    ),
    // second branch (Contacts)
    StatefulShellBranch(
      navigatorKey: _shellNavigatorContactsKey,
      routes: [
        // top route inside branch
        GoRoute(
          path: '/contacts',
          name: 'contacts',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ContactsScreen(),
          ),
        ),
      ],
    ),
    // third branch (For You)
    StatefulShellBranch(
      navigatorKey: _shellNavigatorForYouKey,
      routes: [
        // top route inside branch
        GoRoute(
          path: '/for-you',
          name: 'for-you',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ForYouScreen(),
          ),
          routes: const [],
        ),
      ],
    ),
  ],
);
