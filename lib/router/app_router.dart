import 'package:flutter/material.dart';
import 'package:kumuly_pocket/features/cashier_flow/cashier_flow.dart';
import 'package:kumuly_pocket/features/landing/landing_screen.dart';
import 'package:kumuly_pocket/features/promo_flow/code/promo_code_screen.dart';
import 'package:kumuly_pocket/features/promo_flow/promo_flow.dart';
import 'package:kumuly_pocket/features/promos/promos_screen.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/receive_sats_flow.dart';
import 'package:kumuly_pocket/features/root/root_screen.dart';
import 'package:kumuly_pocket/router/merchant_mode_route.dart';
import 'package:kumuly_pocket/router/pocket_mode_route.dart';
import 'package:kumuly_pocket/router/sign_in_route.dart';
import 'package:kumuly_pocket/router/sign_up_route.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

// Necessary for code-generation to work
part 'app_router.g.dart';

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
        name: 'import-account-flow',
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
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/receive-sats',
        name: 'receive-sats-flow',
        builder: (context, state) => const ReceiveSatsFlow(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/promos',
        name: 'promos',
        builder: (context, state) => const PromosScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/promo/:id',
        name: 'promo-flow',
        builder: (context, state) {
          return PromoFlow(
            id: state.pathParameters['id']!,
            promo: state.extra as Promo,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/promo-code/:id',
        name: 'promo-code',
        builder: (context, state) => PromoCodeScreen(
          id: state.pathParameters['id']!,
          promo: state.extra as Promo,
        ),
      ),
      merchantModeRoute,
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/cashier-mode',
        name: 'cashier-mode',
        builder: (context, state) => const CashierFlow(),
      ),
    ],
  );
}
