import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/shimmer_loader.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(backgroundColor: AppColors.scaffold, appBar: AppBar(title: const Text('My Profile')),
        body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.account_circle_rounded, size: 100, color: AppColors.textMuted), const SizedBox(height: 24),
          const Text('You are not logged in.'), const SizedBox(height: 24),
          ElevatedButton(onPressed: () => context.go('/login'), child: const Text('Login Now')),
        ])));
    }
    return Scaffold(backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('My Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            onPressed: () { FirebaseAuth.instance.signOut(); context.go('/login'); })
        ]),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const ShimmerList(itemCount: 1);
          final data = snap.hasData && snap.data!.exists ? snap.data!.data() as Map<String, dynamic> : <String, dynamic>{};
          return SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
            CircleAvatar(radius: 50, backgroundColor: AppColors.primaryLight, child: Text((data['name'] ?? 'U').toString().substring(0, 1).toUpperCase(), style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppColors.primary))),
            const SizedBox(height: 16),
            Text(data['name'] ?? 'User', style: Theme.of(context).textTheme.displayMedium),
            Text(data['email'] ?? user.email ?? '', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textMuted)),
            const SizedBox(height: 8),
            Chip(label: Text('Role: ${(data['role'] ?? 'member').toString().toUpperCase()}'), backgroundColor: AppColors.primaryLight),
            const SizedBox(height: 32),
            Container(decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Column(children: [
                ListTile(leading: const Icon(Icons.favorite_rounded, color: AppColors.primary), title: const Text('My Donation History'), trailing: const Icon(Icons.chevron_right_rounded), onTap: () {}),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.event_available_rounded, color: AppColors.primary), title: const Text('Registered Events'), trailing: const Icon(Icons.chevron_right_rounded), onTap: () {}),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.settings_rounded, color: AppColors.primary), title: const Text('Account Settings'), trailing: const Icon(Icons.chevron_right_rounded), onTap: () {}),
              ])),
            const SizedBox(height: 40),
          ]));
        }));
  }
}
