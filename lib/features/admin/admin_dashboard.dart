import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/aci_app_bar.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/shimmer_loader.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.scaffold, appBar: const AciAppBar(),
      body: SingleChildScrollView(child: Column(children: [
        Container(width: double.infinity, color: AppColors.primary, padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('ADMIN MANAGEMENT', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70, letterSpacing: 1.2)),
              IconButton(icon: const Icon(Icons.logout_rounded, color: Colors.white), onPressed: () { FirebaseAuth.instance.signOut(); context.go('/login'); }),
            ]),
            const SizedBox(height: 8),
            Text('System Dashboard', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
            Text('Oversee ACI Diocese network operations.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
          ])),
        Padding(padding: const EdgeInsets.all(16), child: GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 12, mainAxisSpacing: 12, children: [
          _adminCard(context, Icons.verified_user_rounded, 'Pastor Approvals', 'Pending requests', () => context.push('/admin/approvals'), AppColors.warningLight, AppColors.warning),
          _adminCard(context, Icons.event_available_rounded, 'Manage Events', 'Add / Edit events', () => context.push('/admin/add-event'), AppColors.primaryLighter, AppColors.primary),
          _adminCard(context, Icons.campaign_rounded, 'Church Updates', 'Post announcements', () => context.push('/admin/add-update'), AppColors.sageLight, AppColors.sage),
          _adminCard(context, Icons.collections_rounded, 'Gallery Uploads', 'Add photo albums', () => context.push('/admin/gallery-upload'), AppColors.lavenderLighter, AppColors.lavender),
        ])),
        SectionHeader('Quick Stats'),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [
          _stat(context, '12', 'Regions'), const SizedBox(width: 12),
          _stat(context, '48+', 'Pastors'), const SizedBox(width: 12),
          _stat(context, '3', 'Pending'),
        ])),
        const SizedBox(height: 40),
      ])));
  }

  Widget _adminCard(BuildContext context, IconData icon, String title, String sub, VoidCallback onTap, Color bg, Color iconColor) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: bg, shape: BoxShape.circle), child: Icon(icon, color: iconColor, size: 28)),
        const Spacer(),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 4),
        Text(sub, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ])));
  }

  Widget _stat(BuildContext context, String val, String label) {
    return Expanded(child: Container(padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(children: [
        Text(val, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
      ])));
  }
}
