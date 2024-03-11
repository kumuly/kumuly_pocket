import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/firebase_options.dart';
import 'package:kumuly_pocket/providers/breez_sdk_providers.dart';
import 'package:kumuly_pocket/providers/local_storage_providers.dart';
import 'package:kumuly_pocket/repositories/onboarding_repository.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_filled_button.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'app_startup.g.dart';

@Riverpod(keepAlive: true)
Future<bool> appStartup(AppStartupRef ref) async {
  ref.onDispose(() {
    // ensure dependent providers are disposed as well
    ref.invalidate(sharedPreferencesProvider);
    ref.invalidate(sqliteProvider);
    ref.invalidate(breezSdkProvider);
    ref.invalidate(onboardingRepositoryProvider);
  });
  // await for all initialization code to be complete before returning
  await Future.wait([
    // Firebase init
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
    // list of providers to be warmed up
    ref.watch(sharedPreferencesProvider.future),
    ref.watch(sqliteProvider.future),
  ]);

  // Firebase App Check after Firebase is initialized
  await FirebaseAppCheck.instance.activate(
    androidProvider:
        kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.appAttest,
  );

  // Breez SDK init
  final breezSdk = ref.watch(breezSdkProvider);

  final isBreezInitialized = await breezSdk.isInitialized();
  if (!isBreezInitialized) {
    breezSdk.initialize();
  }

  // Onboarding init after SharedPreferences is initialized
  await ref.watch(onboardingRepositoryProvider.future);
  return true;
}

/// Widget class to manage asynchronous app initialization
class AppStartupWidget extends ConsumerWidget {
  const AppStartupWidget({super.key, required this.onLoaded});
  final WidgetBuilder onLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);

    return appStartupState.when(
      data: (startedUp) {
        return onLoaded(context);
      },
      loading: () => const AppStartupLoadingWidget(),
      error: (e, st) => AppStartupErrorWidget(
        message: e.toString(),
        onRetry: () => ref.invalidate(appStartupProvider),
      ),
    );
  }
}

class AppStartupLoadingWidget extends StatelessWidget {
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.lightTheme(context),
      darkTheme: CustomTheme.darkTheme(context),
      themeMode: ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AppStartupLoadingScreen(),
    );
  }
}

class AppStartupLoadingScreen extends StatelessWidget {
  const AppStartupLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;

    return TransitionDialog(
      caption: copy.startingTheEngine,
    );
  }
}

class AppStartupErrorWidget extends StatelessWidget {
  const AppStartupErrorWidget(
      {super.key, required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.lightTheme(context),
      darkTheme: CustomTheme.darkTheme(context),
      themeMode: ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: AppStartupErrorScreen(message: message, onRetry: onRetry),
    );
  }
}

class AppStartupErrorScreen extends StatelessWidget {
  const AppStartupErrorScreen({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/illustrations/error_triangle.png',
            ),
            Text(
              copy.somethingWentWrong,
              style: textTheme.display5(
                Palette.lilac[100],
                FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              message,
              style: textTheme.display1(
                Palette.neutral[100],
                FontWeight.w500,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryFilledButton(
                  text: copy.retry,
                  onPressed: onRetry,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
