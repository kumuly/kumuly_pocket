import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';

class ActivitiesScreen extends ConsumerWidget {
  const ActivitiesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final router = GoRouter.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          copy.yourActivity,
          style: Theme.of(context).textTheme.display4(
                Palette.neutral[100]!,
                FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Palette.neutral[100]!,
        iconTheme: IconThemeData(color: Palette.neutral[100]!),
      ),
      body: ListView(
          padding: const EdgeInsets.only(
            top: kSpacing5,
          ),
          children: [
            ActivityListItem(
              leading: DynamicIcon(
                icon: 'assets/icons/posts.svg',
                color: Palette.neutral[80],
              ),
              title: 'Paid promos',
              subtitle: '1 active',
              onTap: () {
                router.pushNamed('paid-promos');
              },
            ),
            ActivityListItem(
              leading: DynamicIcon(
                icon: 'assets/icons/tickets.svg',
                color: Palette.neutral[80],
              ),
              title: 'Your tickets',
              subtitle: '2 active',
            ),
            ActivityListItem(
              leading: Icon(
                Icons.favorite_outline,
                color: Palette.neutral[80],
              ),
              title: 'Liked',
            ),
            ActivityListItem(
              leading: DynamicIcon(
                icon: 'assets/icons/transportation.svg',
                color: Palette.neutral[80],
              ),
              title: 'Transportation',
            ),
            ActivityListItem(
              leading: Icon(
                Icons.store_outlined,
                color: Palette.neutral[80],
              ),
              title: 'Saved merchants',
            ),
          ]),
    );
  }
}

class ActivityListItem extends StatelessWidget {
  const ActivityListItem({
    Key? key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
  }) : super(key: key);

  final Widget leading;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ListTile(
      contentPadding:
          const EdgeInsets.fromLTRB(kSpacing3, 0, kSpacing2, kSpacing2),
      leading: leading,
      title: Text(
        title,
        style: textTheme.display2(
          Palette.neutral[80],
          FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null && subtitle!.isNotEmpty
          ? Text(
              subtitle!,
              style: textTheme.caption1(
                Palette.success[50]!,
                FontWeight.w500,
              ),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right,
        color: Palette.neutral[80],
      ),
      onTap: onTap,
    );
  }
}
