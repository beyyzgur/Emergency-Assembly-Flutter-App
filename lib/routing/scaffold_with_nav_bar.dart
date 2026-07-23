import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/checkin/presentation/check_in_foreground_listener.dart';
import '../l10n/l10n.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CheckInForegroundListener(child: navigationShell),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: context.l10n.navMap,
          ),
          NavigationDestination(
            icon: const Icon(Icons.volunteer_activism_outlined),
            selectedIcon: const Icon(Icons.volunteer_activism),
            label: context.l10n.navNeeds,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: context.l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
