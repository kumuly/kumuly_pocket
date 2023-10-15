import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/widgets/navigation/pocket_mode_scaffold_with_nested_navigation.dart';

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
          pageBuilder: (context, state) => NoTransitionPage(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text('Tab root - pocket'),
              ),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Screen pocket',
                        style: Theme.of(context).textTheme.titleLarge),
                    const Padding(padding: EdgeInsets.all(4)),
                  ],
                ),
              ),
            ), // PocketScreen(),
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
          pageBuilder: (context, state) => NoTransitionPage(
            child: Container(color: Colors.white), // ContactsScreen(),
          ),
          routes: [
            // child route
            GoRoute(
              path: 'add-contact',
              builder: (context, state) => Container(),
            ),
          ],
        ),
      ],
    ),
    // second branch (For You)
    StatefulShellBranch(
      navigatorKey: _shellNavigatorForYouKey,
      routes: [
        // top route inside branch
        GoRoute(
          path: '/for-you',
          name: 'for-you',
          pageBuilder: (context, state) => NoTransitionPage(
            child: Container(color: Colors.white), // ForYouScreen(),
          ),
          routes: const [
            // child route
          ],
        ),
      ],
    ),
  ],
);
