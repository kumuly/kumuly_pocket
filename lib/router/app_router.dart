import 'package:flutter/material.dart';
import 'package:kumuly_pocket/features/root/root_screen.dart';
import 'package:kumuly_pocket/router/pocket_mode_route.dart';
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
      pocketModeRoute,
    ],
  );
}
