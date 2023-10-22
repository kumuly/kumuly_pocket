import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/features/receive_sats/receive_sats_amount_screen.dart';
import 'package:kumuly_pocket/features/receive_sats/receive_sats_codes_screen.dart';
import 'package:kumuly_pocket/features/receive_sats/receive_sats_completed_screen.dart';

final receiveSatsRoute = GoRoute(
  path: '/receive-sats',
  name: 'receive-sats-amount',
  builder: (context, state) => const ReceiveSatsAmountScreen(),
  routes: [
    GoRoute(
      path: 'codes',
      name: 'receive-sats-codes',
      builder: (context, state) => const ReceiveSatsCodesScreen(),
    ),
    GoRoute(
      path: 'completed',
      name: 'receive-sats-completed',
      builder: (context, state) => const ReceiveSatsCompletedScreen(),
    ),
  ],
);
