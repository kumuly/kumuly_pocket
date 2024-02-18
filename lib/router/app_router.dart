import 'package:flutter/material.dart';
import 'package:kumuly_pocket/features/activity/activities_screen.dart';
import 'package:kumuly_pocket/features/activity/paid_promos/paid_promos_screen.dart';
import 'package:kumuly_pocket/features/add_contact_flow/add_contact_flow.dart';
import 'package:kumuly_pocket/features/add_contact_flow/add_contact_scanner_screen.dart';
import 'package:kumuly_pocket/features/app_unlock/app_unlock_screen.dart';
import 'package:kumuly_pocket/features/cashier_flow/cashier_flow.dart';
import 'package:kumuly_pocket/features/chat/chat_screen.dart';
import 'package:kumuly_pocket/features/contact_id/contact_id_screen.dart';
import 'package:kumuly_pocket/features/onboarding/new_user_flow/new_user_flow.dart';
import 'package:kumuly_pocket/features/onboarding/onboarding_start_screen.dart';
import 'package:kumuly_pocket/features/onboarding/recovery_flow/recovery_flow.dart';
import 'package:kumuly_pocket/features/pocket/payment_details/pocket_payment_details_screen.dart';
import 'package:kumuly_pocket/features/promo_flow/code/promo_code_screen.dart';
import 'package:kumuly_pocket/features/promo_flow/promo_flow.dart';
import 'package:kumuly_pocket/features/promo_validation_flow/promo_validation_flow.dart';
import 'package:kumuly_pocket/features/promos/promos_screen.dart';
import 'package:kumuly_pocket/features/receive_sats_flow/receive_sats_flow.dart';
import 'package:kumuly_pocket/features/seed_backup_flow/seed_backup_flow.dart';
import 'package:kumuly_pocket/features/send_sats_flow/errors/send_sats_expired_invoice_screen.dart';
import 'package:kumuly_pocket/features/send_sats_flow/input/send_sats_scanner_screen.dart';
import 'package:kumuly_pocket/features/send_sats_flow/send_sats_flow.dart';
import 'package:kumuly_pocket/features/settings/bitcoin_unit_settings_screen.dart';
import 'package:kumuly_pocket/features/settings/local_currency_settings_screen.dart';
import 'package:kumuly_pocket/features/settings/location_settings_screen.dart';
import 'package:kumuly_pocket/repositories/onboarding_repository.dart';
import 'package:kumuly_pocket/router/merchant_mode_route.dart';
import 'package:kumuly_pocket/router/pocket_mode_route.dart';
import 'package:kumuly_pocket/view_models/promo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

// Necessary for code-generation to work
part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoute {
  appUnlock,
  appResume,
  onboarding,
  pocket,
  newUserFlow,
  recoveryFlow,
  paymentDetails,
  contactId,
  activity,
  paidPromos,
  bitcoinUnit,
  localCurrency,
  location,
  seedBackupFlow,
  receiveSatsFlow,
  sendSatsFlow,
  sendSatsScanner,
  expiredInvoice,
  addContactFlow,
  addContactScanner,
  chat,
  promos,
  promoFlow,
  promoCode,
  merchantModeFlow,
  cashierModeFlow,
  promoValidationFlow,
  sales,
  cashier,
  myPosts,
  contacts,
  forYou,
}

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/appUnlock',
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      final onboardingRepository =
          ref.watch(onboardingRepositoryProvider).requireValue;
      final isOnboardingComplete = onboardingRepository.isOnboardingComplete();
      final path = state.uri.path;

      if (!isOnboardingComplete) {
        if (path != '/onboarding' &&
            path != '/newUser' &&
            path != '/recovery') {
          return '/onboarding';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/appUnlock',
        name: AppRoute.appUnlock.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AppUnlockScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        name: AppRoute.onboarding.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingStartScreen(),
        ),
      ),
      GoRoute(
        path: '/newUser',
        name: AppRoute.newUserFlow.name,
        builder: (context, state) => const NewUserFlow(),
      ),
      GoRoute(
        path: '/recovery',
        name: AppRoute.recoveryFlow.name,
        builder: (context, state) => const RecoveryFlow(),
      ),
      pocketModeRoute,
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/paymentDetails/:hash',
        name: AppRoute.paymentDetails.name,
        builder: (context, state) {
          final hash = state.pathParameters['hash']!;
          return PocketPaymentDetailsScreen(hash: hash);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/contactId',
        name: AppRoute.contactId.name,
        builder: (context, state) => const ContactIdScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/activity',
        name: AppRoute.activity.name,
        builder: (context, state) => const ActivitiesScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/paidPromos',
        name: AppRoute.paidPromos.name,
        builder: (context, state) => const PaidPromosScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/bitcoinUnit',
        name: AppRoute.bitcoinUnit.name,
        builder: (context, state) => const BitcoinUnitSettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/localCurrency',
        name: AppRoute.localCurrency.name,
        builder: (context, state) => const LocalCurrencySettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/location',
        name: AppRoute.location.name,
        builder: (context, state) => const LocationSettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/seedBackup',
        name: AppRoute.seedBackupFlow.name,
        builder: (context, state) => const SeedBackupFlow(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/receiveSats',
        name: AppRoute.receiveSatsFlow.name,
        builder: (context, state) => const ReceiveSatsFlow(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/sendSats',
        name: AppRoute.sendSatsFlow.name,
        builder: (context, state) => const SendSatsFlow(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/sendSatsScanner',
        name: AppRoute.sendSatsScanner.name,
        builder: (context, state) => const SendSatsScannerScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/expiredInvoice',
        name: AppRoute.expiredInvoice.name,
        builder: (context, state) => const SendSatsExpiredInvoiceScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/addContact',
        name: AppRoute.addContactFlow.name,
        builder: (context, state) => const AddContactFlow(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/addContactScanner',
        name: AppRoute.addContactScanner.name,
        builder: (context, state) => const AddContactScannerScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/chat/:id',
        name: AppRoute.chat.name,
        builder: (context, state) => ChatScreen(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/promos',
        name: AppRoute.promos.name,
        builder: (context, state) => const PromosScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/promo/:id',
        name: AppRoute.promoFlow.name,
        builder: (context, state) {
          return PromoFlow(
            id: state.pathParameters['id']!,
            promo: state.extra as Promo,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/promoCode/:id',
        name: AppRoute.promoCode.name,
        builder: (context, state) => PromoCodeScreen(
          id: state.pathParameters['id']!,
          promo: state.extra as Promo,
        ),
      ),
      merchantModeRoute,
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/cashierMode',
        name: AppRoute.cashierModeFlow.name,
        builder: (context, state) => const CashierFlow(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/promoValidation',
        name: AppRoute.promoValidationFlow.name,
        builder: (context, state) => const PromoValidationFlow(),
      ),
    ],
  );
}
