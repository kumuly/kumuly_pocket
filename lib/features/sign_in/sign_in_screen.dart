import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/enums/time_unit.dart';
import 'package:kumuly_pocket/services/account_service.dart';
import 'package:kumuly_pocket/services/authentication_service.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_border_button.dart';
import 'package:kumuly_pocket/widgets/buttons/primary_text_button.dart';
import 'package:kumuly_pocket/features/sign_in/sign_in_controller.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final copy = AppLocalizations.of(context)!;

    final signInController = signInControllerProvider(
      ref.watch(firebaseAuthenticationServiceProvider),
      ref.watch(sharedPreferencesAccountServiceProvider),
      ref.watch(breezeSdkLightningNodeServiceProvider),
    );
    final signInControllerNotifier = ref.read(signInController.notifier);
    final accountsList = ref.watch(signInController).accounts;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          copy.signInWith,
          style: textTheme.display4(
            Palette.neutral[100],
            FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.white,
        iconTheme: IconThemeData(color: Palette.neutral[100]),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              itemCount: accountsList.length,
              itemBuilder: (BuildContext context, int index) {
                final account = accountsList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: Palette.neutral[50]!,
                        width: 1.0,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),

                      leading: Icon(Icons.account_circle,
                          size: 40,
                          color: Palette
                              .neutral[50]), // Example icon for user account
                      title: Text(
                        account.alias,
                        style: textTheme.display3(
                          Palette.neutral[100],
                          FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.partialNodeId,
                            style: textTheme.body2(
                              Palette.neutral[50],
                              FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            switch (account.timeSinceLastLogin.$2) {
                              TimeUnit.days =>
                                '${copy.lastSignInSince} ${account.timeSinceLastLogin.$1} ${copy.daysAgo}',
                              TimeUnit.hours =>
                                '${copy.lastSignInSince} ${account.timeSinceLastLogin.$1} ${copy.hoursAgo}',
                              TimeUnit.minutes =>
                                '${copy.lastSignInSince} ${account.timeSinceLastLogin.$1} ${copy.minutesAgo}',
                              TimeUnit.seconds =>
                                '${copy.lastSignInSince} ${account.timeSinceLastLogin.$1} ${copy.secondsAgo}',
                              _ => copy.hasNotSignedInYet,
                            },
                            style: TextStyle(
                              color: Palette.neutral[80],
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Palette.neutral[100],
                      ),
                      onTap: () {
                        signInControllerNotifier.setSelectedAccount(account);
                        context.pushNamed('insert-pin');
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          const SizedBox(height: kMediumSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PrimaryBorderButton(
                leadingIcon: Icon(Icons.account_circle_outlined,
                    color: Palette.neutral[100]),
                text: copy.importAccount,
                onPressed: () {
                  context.pushNamed('import-account-flow');
                },
                color: Palette.neutral[100],
              ),
            ],
          ),
          const SizedBox(height: kMediumSpacing),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryTextButton(
                leadingIcon: Icon(Icons.add, color: Palette.neutral[100]),
                text: copy.createAccount,
                onPressed: () {
                  context.pushNamed('sign-up');
                },
                color: Palette.neutral[100],
              ),
            ],
          ),
          const SizedBox(height: kMediumSpacing),
        ],
      ),
    );
  }
}
