import 'package:go_router/go_router.dart';

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
