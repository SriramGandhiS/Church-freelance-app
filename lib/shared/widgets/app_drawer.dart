import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(child: ListView(padding: EdgeInsets.zero, children: [
        Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.asset('assets/images/aci_logo.png', width: 60, height: 60,
            errorBuilder: (_, __, ___) => const Icon(Icons.church_rounded, size: 60, color: AppColors.primary)),
          const SizedBox(height: 16),
          Text(AppStrings.appName, style: Theme.of(context).textTheme.headlineMedium),
          Text(AppStrings.tagline, style: Theme.of(context).textTheme.bodySmall),
        ])),
        const Divider(),
        _tile(context, Icons.home_rounded, 'Home', '/home'),
        ListTile(
          leading: const Icon(Icons.info_outline_rounded, color: AppColors.primary),
          title: Text('About Diocese', style: GoogleFonts.sourceSans3(
            fontSize: 14, fontWeight: FontWeight.w600)),
          onTap: () { Navigator.pop(context); context.push('/about'); },
        ),
        ListTile(
          leading: const Icon(Icons.church_rounded, color: AppColors.primary),
          title: Text('Church Directory', style: GoogleFonts.sourceSans3(
            fontSize: 14, fontWeight: FontWeight.w600)),
          onTap: () { Navigator.pop(context); context.push('/churches'); },
        ),
        _tile(context, Icons.person_rounded, 'Bishop & Founder', '/bishop'),
        _tile(context, Icons.account_balance_rounded, 'The Synod', '/synod'),
        _tile(context, Icons.event_rounded, 'Events', '/events'),
        _tile(context, Icons.favorite_rounded, 'Donate', '/donate'),
        _tile(context, Icons.volunteer_activism_rounded, 'Prayer Request', '/prayer'),
        _tile(context, Icons.call_rounded, 'Contact Us', '/contact'),
        _tile(context, Icons.add_circle_outline_rounded, 'Join Community', '/join'),
        const Divider(),
        if (user == null)
          _tile(context, Icons.login_rounded, 'Login / My Account', '/login')
        else
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.error),
            title: Text('Logout', style: TextStyle(color: AppColors.error)),
            onTap: () { FirebaseAuth.instance.signOut(); context.go('/login'); },
          ),
      ])),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String label, String route) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary), 
      title: Text(label, style: GoogleFonts.sourceSans3(fontSize: 14, fontWeight: FontWeight.w600)), 
      onTap: () {
        Navigator.pop(context);
        if (route == '/home' || route == '/login') {
          context.go(route);
        } else {
          context.push(route);
        }
      }
    );
  }
}
