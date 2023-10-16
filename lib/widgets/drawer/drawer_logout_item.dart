import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawerLogoutItem extends StatelessWidget {
  const DrawerLogoutItem({super.key});

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;

    final router = GoRouter.of(context);

    return ListTile(
      title: Center(child: Text(copy.logout)),
      titleTextStyle: Theme.of(context).textTheme.display1(
            Palette.error[100],
            FontWeight.w600,
          ),
      onTap: () async {
        try {
          showTransitionDialog(context, copy.oneMomentPlease);
        } catch (e) {
          print(e);
          router.pop();
        }
      },
    );
  }
}
