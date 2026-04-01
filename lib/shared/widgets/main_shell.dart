import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'bottom_nav_bar.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _calcIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.path;
    if (loc.startsWith('/home'))    return 0;
    if (loc.startsWith('/synod'))   return 1;
    if (loc.startsWith('/support')) return 3;
    if (loc.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNav(currentIndex: _calcIndex(context)),
    );
  }
}
