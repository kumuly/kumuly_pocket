import 'package:flutter/material.dart';
import 'package:kumuly_pocket/features/landing/landing_screen.dart';
import 'package:kumuly_pocket/features/root/root_screen.dart';
import 'package:kumuly_pocket/router/merchant_mode_route.dart';
import 'package:kumuly_pocket/router/pocket_mode_route.dart';
import 'package:kumuly_pocket/router/promos_route.dart';
import 'package:kumuly_pocket/router/receive_sats_route.dart';
import 'package:kumuly_pocket/router/sign_in_route.dart';
import 'package:kumuly_pocket/router/sign_up_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

// Necessary for code-generation to work
part 'app_router.g.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/',
        name: 'root',
        builder: (context, state) => const RootScreen(),
      ),
      GoRoute(
        path: '/landing',
        name: 'landing',
        builder: (context, state) => const LandingScreen(),
      ),
      signUpRoute,
      signInRoute,
      GoRoute(
        path: '/import-account',
        name: 'import-account',
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('Import Account'),
            centerTitle: true,
          ),
          body: const Center(
            child: Text('>>> Insert seed phrase here <<<'),
          ),
        ),
      ),
      pocketModeRoute,
      receiveSatsRoute,
      promosRoute,
      ...promoRoute,
      merchantModeRoute,
    ],
  );
}
