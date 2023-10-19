import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final signInRoute = GoRoute(
  path: '/sign-in',
  name: 'sign-in',
  builder: (context, state) => Container(
    color: Colors.white,
    child: const Text('Sign in screen'),
  ), // SignInScreen(),
  routes: [
    GoRoute(
      path: 'insert-pin',
      name: 'insert-pin',
      builder: (context, state) => Container(
        color: Colors.white,
        child: const Text('Insert pin screen'),
      ), // InsertPinScreen(),
    ),
  ],
);
