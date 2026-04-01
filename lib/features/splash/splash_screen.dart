import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final role = doc.data()?['role'] as String? ?? 'user';
      if (!mounted) return;
      if (role == 'admin') { context.go('/admin/home'); return; }
      if (role == 'pastor') { context.go('/pastor/home'); return; }
      context.go('/home'); return;
    }
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(colors: [AppColors.primaryLighter, AppColors.surface], radius: 0.8),
        ),
        child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/images/aci_logo.png', width: 120, height: 120,
            errorBuilder: (_, __, ___) => const Icon(Icons.church_rounded, size: 120, color: AppColors.primary))
              .animate().fade(duration: 800.ms).scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: 24),
          Text(AppStrings.appName, style: Theme.of(context).textTheme.displayMedium)
              .animate().fade(delay: 400.ms, duration: 600.ms).slideY(begin: 0.2),
          const SizedBox(height: 8),
          Text(AppStrings.tagline, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textMuted))
              .animate().fade(delay: 600.ms, duration: 600.ms),
        ])),
      ),
    );
  }
}
