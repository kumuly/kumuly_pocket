import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/features/sales/sales_screen.dart';
import 'package:kumuly_pocket/features/merchant_mode/merchant_mode_scaffold_with_nested_navigation.dart';

// Private navigators
final _shellNavigatorSalesKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellSales');
final _shellNavigatorCashierKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellCashier');
final _shellNavigatorMyPostsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellMyPosts');

final merchantModeRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return MerchantModeScaffoldWithNestedNavigation(
      navigationShell: navigationShell,
    );
  },
  branches: [
    // first branch (Sales)
    StatefulShellBranch(
      navigatorKey: _shellNavigatorSalesKey,
      routes: [
        // top route inside branch
        GoRoute(
          path: '/sales',
          name: 'sales',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SalesScreen(),
          ),
          routes: const [
            // child route
          ],
        ),
      ],
    ),
    // second branch (Cashier)
    StatefulShellBranch(
      navigatorKey: _shellNavigatorCashierKey,
      routes: [
        // top route inside branch
        GoRoute(
          path: '/cashier',
          name: 'cashier',
          pageBuilder: (context, state) => NoTransitionPage(
            child: Container(color: Colors.white),
          ),
          redirect: (context, state) => '/cashier-mode',
        ),
      ],
    ),
    // third branch (My Posts)
    StatefulShellBranch(
      navigatorKey: _shellNavigatorMyPostsKey,
      routes: [
        // top route inside branch
        GoRoute(
          path: '/my-posts',
          name: 'my-posts',
          pageBuilder: (context, state) => NoTransitionPage(
            child: Container(color: Colors.white), // MyPostsScreen(),
          ),
          routes: const [
            // child route
          ],
        ),
      ],
    ),
  ],
);
