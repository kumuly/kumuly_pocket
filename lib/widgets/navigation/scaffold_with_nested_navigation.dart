// Stateful nested navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/icons/dynamic_icon.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
    required this.destinationIcons,
    required this.destinationLabels,
  }) : super(key: key);

  final StatefulNavigationShell navigationShell;
  final List<dynamic> destinationIcons;
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
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white, // Set the background color to white
        elevation: 0,
        selectedIndex: navigationShell.currentIndex,
        destinations: List.generate(
          destinationIcons.length,
          (index) => NavigationDestination(
            icon: DynamicIcon(
              icon: destinationIcons[index],
              color: Palette.russianViolet[100]!,
              size: 24.0,
            ),
            label: destinationLabels[index],
          ),
        ),
        onDestinationSelected: _goBranch,
      ),
    );
  }
}
