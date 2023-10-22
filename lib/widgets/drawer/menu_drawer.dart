import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/theme/custom_theme.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';
import 'package:kumuly_pocket/widgets/shadows/bottom_shadow.dart';

class MenuDrawer extends ConsumerWidget {
  const MenuDrawer(
      {Key? key,
      required this.alias,
      required this.avatarAssetName,
      required this.children})
      : super(key: key);

  final String alias;
  final String avatarAssetName;

  /// The widgets to display in the drawer beneath the ID header.
  /// Typically, this will be a list of
  /// [DrawerItem]s, [DrawerSectionTitle]s and [DrawerSectionSeparator]s.
  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      backgroundColor: Colors.white,
      elevation: 0,
      width: screenWidth,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: kMediumSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const DynamicIcon(icon: Icons.arrow_back_outlined),
                      onPressed: GoRouter.of(context).pop,
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Palette.neutral[30]!,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(avatarAssetName),
                        radius: 24.0,
                      ),
                      const SizedBox(width: kSmallSpacing),
                      Text(
                        alias,
                        style: Theme.of(context)
                            .textTheme
                            .display2(
                              Palette.neutral[80],
                              FontWeight.normal,
                            )
                            .copyWith(
                              letterSpacing: 0.0,
                            ),
                      ),
                      const SizedBox(width: kSmallSpacing),
                      const Spacer(),
                      VerticalDivider(
                        indent: 8.0,
                        endIndent: 8.0,
                        width: 1.0,
                        thickness: 1.0,
                        color: Palette.neutral[30]!,
                      ),
                      const SizedBox(width: kSmallSpacing),
                      Image.asset(
                        'assets/images/dummy_id_qr.png',
                        width: 32.0,
                        height: 32.0,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: children,
                ),
              ),
            ],
          ),
          BottomShadow(
            width: screenWidth,
          ),
        ],
      ),
    );
  }
}
