import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/aci_app_bar.dart';

class PastorDashboard extends StatelessWidget {
  const PastorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.scaffold, appBar: const AciAppBar(),
      body: SingleChildScrollView(child: Column(children: [
        Container(width: double.infinity, color: AppColors.primary, padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('PASTOR PORTAL', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70, letterSpacing: 1.2)),
              IconButton(icon: const Icon(Icons.logout_rounded, color: Colors.white), onPressed: () { FirebaseAuth.instance.signOut(); context.go('/login'); }),
            ]),
            const SizedBox(height: 8),
            Text('Welcome, Minister', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
            Text('Manage your profile and access resources.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
          ])),
        Padding(padding: const EdgeInsets.all(16), child: GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 12, mainAxisSpacing: 12, children: [
          _card(context, Icons.person_rounded, 'My Profile', 'Update details', () => context.push('/pastor/profile'), AppColors.primaryLighter, AppColors.primary),
          _card(context, Icons.folder_shared_rounded, 'Circulars', 'Official documents', () {}, AppColors.lavenderLighter, AppColors.lavender),
          _card(context, Icons.video_camera_front_rounded, 'Meetings', 'Synod zoom links', () => context.push('/pastor/meetings'), AppColors.sageLight, AppColors.sage),
          _card(context, Icons.help_center_rounded, 'Support', 'Contact admin', () => context.push('/support'), AppColors.blushLight, AppColors.blush),
        ])),
      ])));
  }

  Widget _card(BuildContext context, IconData icon, String title, String sub, VoidCallback onTap, Color bg, Color iconColor) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: bg, shape: BoxShape.circle), child: Icon(icon, color: iconColor, size: 28)),
        const Spacer(),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 4),
        Text(sub, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ])));
  }
}
