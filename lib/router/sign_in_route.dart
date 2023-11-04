import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/features/sign_in/insert_pin_screen.dart';
import 'package:kumuly_pocket/features/sign_in/sign_in_screen.dart';

// Todo: only show insert pin screen and make the app single-account
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
