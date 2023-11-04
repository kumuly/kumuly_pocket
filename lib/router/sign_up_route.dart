import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/features/sign_up/assign_alias_screen.dart';
import 'package:kumuly_pocket/features/sign_up/confirm_pin_screen.dart';
import 'package:kumuly_pocket/features/sign_up/create_pin_screen.dart';
import 'package:kumuly_pocket/features/sign_up/sign_up_screen.dart';

// Todo: change to PageView instead of separate routes
final signUpRoute = GoRoute(
  path: '/sign-up',
  name: 'sign-up',
  builder: (context, state) => const SignUpScreen(),
  routes: [
    GoRoute(
      path: 'assign-alias',
      name: 'assign-alias',
      builder: (context, state) => const AssignAliasScreen(),
    ),
    GoRoute(
      path: 'create-pin',
      name: 'create-pin',
      builder: (context, state) => const CreatePinScreen(),
    ),
    GoRoute(
      path: 'confirm-pin',
      name: 'confirm-pin',
      builder: (context, state) => const ConfirmPinScreen(),
    ),
  ],
);
