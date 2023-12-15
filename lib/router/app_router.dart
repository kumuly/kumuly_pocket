import 'package:flutter/material.dart';
import 'package:kumuly_pocket/features/activity/activities_screen.dart';
import 'package:kumuly_pocket/features/activity/paid_promos/paid_promos_screen.dart';
import 'package:kumuly_pocket/features/add_contact_flow/add_contact_flow.dart';
import 'package:kumuly_pocket/features/add_contact_flow/add_contact_scanner_screen.dart';
import 'package:kumuly_pocket/features/cashier_flow/cashier_flow.dart';
import 'package:kumuly_pocket/features/chat/chat_screen.dart';
import 'package:kumuly_pocket/features/contact_id/contact_id_screen.dart';
import 'package:kumuly_pocket/features/landing/landing_screen.dart';
import 'package:kumuly_pocket/features/promo_flow/code/promo_code_screen.dart';
import 'package:kumuly_pocket/features/promo_flow/promo_flow.dart';
import 'package:kumuly_pocket/features/promo_validation_flow/promo_validation_flow.dart';
import 'package:kumuly_pocket/features/promos/promos_screen.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/receive_sats_flow.dart';
import 'package:kumuly_pocket/features/root/root_screen.dart';
import 'package:kumuly_pocket/features/seed_backup_flow/seed_backup_flow.dart';
import 'package:kumuly_pocket/features/send_sats_flow/errors/send_sats_expired_invoice_screen.dart';
import 'package:kumuly_pocket/features/send_sats_flow/input/send_sats_scanner_screen.dart';
import 'package:kumuly_pocket/features/send_sats_flow/send_sats_flow.dart';
import 'package:kumuly_pocket/features/settings/bitcoin_unit_settings_screen.dart';
import 'package:kumuly_pocket/features/settings/local_currency_settings_screen.dart';
import 'package:kumuly_pocket/features/settings/location_settings_screen.dart';
import 'package:kumuly_pocket/router/merchant_mode_route.dart';
import 'package:kumuly_pocket/router/pocket_mode_route.dart';
import 'package:kumuly_pocket/router/sign_in_route.dart';
import 'package:kumuly_pocket/router/sign_up_route.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
import 'package:kumuly_pocket/features/pin/pin_screen.dart';
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
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/pin',
        name: 'pin',
        builder: (context, state) {
          return PinScreen(
            confirmHandler: state.extra as void Function(),
          );
        },
      ),
      pocketModeRoute,
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/contact-id',
        name: 'contact-id',
        builder: (context, state) => const ContactIdScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/activity',
        name: 'activity',
        builder: (context, state) => const ActivitiesScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/paid-promos',
        name: 'paid-promos',
        builder: (context, state) => const PaidPromosScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/bitcoin-unit',
        name: 'bitcoin-unit',
        builder: (context, state) => const BitcoinUnitSettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/local-currency',
        name: 'local-currency',
        builder: (context, state) => const LocalCurrencySettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/location',
        name: 'location',
        builder: (context, state) => const LocationSettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/seed-backup',
        name: 'seed-backup-flow',
        builder: (context, state) => const SeedBackupFlow(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/receive-sats',
        name: 'receive-sats-flow',
        builder: (context, state) => const ReceiveSatsFlow(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/send-sats',
        name: 'send-sats-flow',
        builder: (context, state) => const SendSatsFlow(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/send-sats-scanner',
        name: 'send-sats-scanner',
        builder: (context, state) => const SendSatsScannerScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/expired-invoice',
        name: 'expired-invoice',
        builder: (context, state) => const SendSatsExpiredInvoiceScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/add-contact',
        name: 'add-contact-flow',
        builder: (context, state) => const AddContactFlow(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/add-contact-scanner',
        name: 'add-contact-scanner',
        builder: (context, state) => const AddContactScannerScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/chat/:id',
        name: 'chat',
        builder: (context, state) => ChatScreen(
          id: int.parse(state.pathParameters['id']!),
        ),
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
        name: 'cashier-mode-flow',
        builder: (context, state) => const CashierFlow(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/promo-validation',
        name: 'promo-validation-flow',
        builder: (context, state) => const PromoValidationFlow(),
      ),
    ],
  );
}
