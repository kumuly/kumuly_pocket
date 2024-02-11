import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/repositories/onboarding_repository.dart';
import 'package:kumuly_pocket/router/app_router.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';

// Todo: Add AppLifecycleListener
// show PIN screen at app start and app resume
// on app start init nodes and wallets, on app resume pop the PIN screen

class KumulyPocketApp extends ConsumerStatefulWidget {
  const KumulyPocketApp({super.key});

  @override
  KumulyPocketAppState createState() => KumulyPocketAppState();
}

class KumulyPocketAppState extends ConsumerState<KumulyPocketApp> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();

    // Initialize the AppLifecycleListener class and pass callbacks
    _listener = AppLifecycleListener(
      onRestart: () {
        // Push the app lock screen if the user has already onboarded and is not
        //  already on it when the app is restarted.
        final onboardingRepository =
            ref.read(onboardingRepositoryProvider).requireValue;
        final isOnboardingComplete =
            onboardingRepository.isOnboardingComplete();
        final router = ref.read(appRouterProvider);
        if (isOnboardingComplete &&
            router.routeInformationProvider.value.uri.path != '/appUnlock') {
          router.pushNamed(AppRoute.appUnlock.name);
        }
      },
    );
  }

  @override
  void dispose() {
    _listener.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Kumuly Pocket',
      theme: CustomTheme.lightTheme(context),
      darkTheme: CustomTheme.darkTheme(context),
      themeMode: ThemeMode.light,
      routeInformationParser: appRouter.routeInformationParser,
      routeInformationProvider: appRouter.routeInformationProvider,
      routerDelegate: appRouter.routerDelegate,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
