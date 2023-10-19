import 'package:go_router/go_router.dart';

final signInRoute = GoRoute(
  path: '/sign-in',
  name: 'sign-in',
  builder: (context, state) => const SignInScreen(),
  routes: [
    GoRoute(
      path: 'insert-pin',
      name: 'insert-pin',
      builder: (context, state) => const InsertPinScreen(),
    ),
  ],
);
