// Stateful nested navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.scaffoldKey,
    required this.navigationShell,
    this.endDrawer,
    required this.destinationIcons,
    this.destinationSelectedIcons,
    required this.destinationLabels,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final StatefulNavigationShell navigationShell;
  final Widget? endDrawer;
  final List<dynamic> destinationIcons;
  final List<dynamic>? destinationSelectedIcons;
  final List<String> destinationLabels;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: navigationShell,
      endDrawer: endDrawer,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Palette.neutral[30]!, // Color of the border
              width: 1.0, // Width of the border
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          destinations: List.generate(
            destinationIcons.length,
            (index) => NavigationDestination(
              icon: DynamicIcon(
                icon: destinationIcons[index],
                color: Palette.neutral[50]!,
                size: 24.0,
              ),
              selectedIcon: destinationSelectedIcons != null
                  ? DynamicIcon(
                      icon: destinationSelectedIcons?[index],
                      color: Palette.russianViolet[100]!,
                      size: 24.0,
                    )
                  : null,
              label: destinationLabels[index],
            ),
          ),
          onDestinationSelected: _goBranch,
        ),
      ),
    );
  }
}
