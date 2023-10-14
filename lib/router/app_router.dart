import 'package:flutter/material.dart';
import 'package:kumuly_pocket/features/root/root_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

// Necessary for code-generation to work
part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'root',
        builder: (context, state) => const RootScreen(),
      ),
      GoRoute(
        path: '/pocket',
        name: 'pocket',
        builder: (context, state) => Container(
          color: Colors.blue,
        ),
      ),
    ],
  );
}
