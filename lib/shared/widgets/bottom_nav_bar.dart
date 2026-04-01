import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(color: AppColors.surface, border: const Border(top: BorderSide(color: AppColors.divider, width: 1))),
      child: SafeArea(
        top: false,
        child: Row(children: [
          _buildItem(context, 0, Icons.home_rounded, 'Home', '/home'),
          _buildItem(context, 1, Icons.account_balance_rounded, 'Synod', '/synod'),
          Expanded(child: GestureDetector(
            onTap: () => _showCenterSheet(context),
            child: Center(child: Transform.translate(offset: const Offset(0, -10), child: Container(
              width: 52, height: 52,
              decoration: BoxDecoration(color: AppColors.primaryLighter, shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1.5)),
              child: Center(child: Image.asset('assets/images/aci_logo.png', width: 26, height: 26,
                errorBuilder: (_, __, ___) => const Icon(Icons.add_rounded, color: AppColors.primary, size: 26))),
            ))),
          )),
          _buildItem(context, 3, Icons.volunteer_activism_rounded, 'Support', '/support'),
          _buildItem(context, 4, Icons.person_rounded, 'Profile', '/profile'),
        ]),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, IconData icon, String label, String route) {
    final active = currentIndex == index;
    return Expanded(child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.go(route),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 22, color: active ? AppColors.primary : AppColors.textMuted),
        const SizedBox(height: 3),
        Text(label, style: GoogleFonts.sourceSans3(fontSize: 10, fontWeight: FontWeight.w600, color: active ? AppColors.primary : AppColors.textMuted)),
      ]),
    ));
  }

  void _showCenterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context, backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 12),
        Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 16),
        Text('How can we help?', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        ListTile(leading: const Icon(Icons.favorite_rounded, color: AppColors.blush), title: const Text('Donate / Offerings'), onTap: () { Navigator.pop(context); context.push('/donate'); }),
        ListTile(leading: Icon(Icons.volunteer_activism_rounded, color: AppColors.lavender), title: const Text('Prayer Request'), onTap: () { Navigator.pop(context); context.push('/prayer'); }),
        ListTile(leading: const Icon(Icons.groups_rounded, color: AppColors.sage), title: const Text('Join Community'), onTap: () { Navigator.pop(context); context.push('/join'); }),
        ListTile(leading: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary), title: const Text('Admin Panel'), subtitle: const Text('Manage applications', style: TextStyle(fontSize: 11)), onTap: () { Navigator.pop(context); context.push('/admin-login'); }),
        const SizedBox(height: 20),
      ])),
    );
  }
}
