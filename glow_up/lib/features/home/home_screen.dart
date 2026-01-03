import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    
    int getIndex() {
      if (location.startsWith('/home/habits')) return 1;
      if (location.startsWith('/home/looks')) return 2;
      if (location.startsWith('/home/charisma')) return 3;
      if (location.startsWith('/home/settings')) return 4;
      return 0;
    }

    void onItemTapped(int index) {
      switch (index) {
        case 0: context.go('/home/index'); break;
        case 1: context.go('/home/habits'); break;
        case 2: context.go('/home/looks'); break;
        case 3: context.go('/home/charisma'); break;
        case 4: context.go('/home/settings'); break;
      }
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: getIndex(),
        onDestinationSelected: onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(LucideIcons.home), label: 'Home'),
          NavigationDestination(icon: Icon(LucideIcons.checkCircle), label: 'Habits'),
          NavigationDestination(icon: Icon(LucideIcons.camera), label: 'Looks'),
          NavigationDestination(icon: Icon(LucideIcons.zap), label: 'Charisma'),
          NavigationDestination(icon: Icon(LucideIcons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
