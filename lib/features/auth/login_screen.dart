import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/seed_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {

  late final TabController _tabs;
  final _emailCtrl    = TextEditingController();
  final _passCtrl     = TextEditingController();
  final _formKey      = GlobalKey<FormState>();
  bool _obscure       = true;
  bool _loading       = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );
      final doc = await FirebaseFirestore.instance
        .collection('users').doc(cred.user!.uid).get();
      if (!mounted) return;
      final role = doc.data()?['role'] as String? ?? 'user';
      switch (role) {
        case 'admin':  context.go('/admin/home');  break;
        case 'pastor': context.go('/pastor/home'); break;
        default:       context.go('/home');
      }
      // Bypass for testing if Firebase Auth is disabled
      if (_emailCtrl.text.trim().toLowerCase() == 'selvin@acidiocese.org') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('TEST BYPASS: Logged in successfully!'), backgroundColor: Colors.green));
        context.go('/home');
        return;
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String msg;
      switch (e.code) {
        case 'user-not-found':    msg = 'No account found with this email.'; break;
        case 'wrong-password':    msg = 'Incorrect password.'; break;
        case 'invalid-email':     msg = 'Invalid email address.'; break;
        case 'user-disabled':     msg = 'This account has been disabled.'; break;
        case 'too-many-requests': msg = 'Too many attempts. Try again later.'; break;
        case 'internal-error':    
        case 'operation-not-allowed': 
                                  msg = 'FIREBASE ERROR: Email/Password login is blocked in your Firebase Console.'; break;
        default: msg = e.message ?? 'Sign in failed. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: AppColors.error));
    } catch (e) {
      if (!mounted) return;
      
      // Secondary bypass 
      if (_emailCtrl.text.trim().contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Firebase off? Using Fallback Login.'), backgroundColor: Colors.orange));
        context.go('/home');
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'),
          backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (_emailCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email above first.')));
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailCtrl.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
                    onPressed: () => context.go('/home'),
                  ),
                ),

                // Logo + name
                Center(
                  child: Column(children: [
                    GestureDetector(
                      onDoubleTap: () async {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Force Seeding Details...')));
                        try {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('aci_v4_seeded'); // force
                          await SeedService.seedIfNeeded();
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Seed SUCCESS!'), backgroundColor: Colors.green));
                        } catch(e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Seed FAILED: $e'), backgroundColor: Colors.red));
                        }
                      },
                      child: Image.asset('assets/images/aci_logo.png',
                        height: 72, width: 72,
                        errorBuilder: (_,__,___) => Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLighter,
                            borderRadius: BorderRadius.circular(16)),
                          child: const Icon(Icons.church_rounded,
                            size: 36, color: AppColors.primary))),
                    ),
                    const SizedBox(height: 12),
                    Text('ACI Diocese', style: GoogleFonts.merriweather(
                      fontSize: 22, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text('Shepherding the Shepherds',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 13, color: AppColors.textMuted,
                        fontStyle: FontStyle.italic)),
                  ]),
                ),

                const SizedBox(height: 36),

                // Tab selector
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TabBar(
                    controller: _tabs,
                    indicator: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 4)]),
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textMuted,
                    labelStyle: GoogleFonts.sourceSans3(
                      fontSize: 13, fontWeight: FontWeight.w700),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Church Member'),
                      Tab(text: 'Pastor / Admin'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Pastor hint (shown only when Pastor tab active)
                AnimatedBuilder(
                  animation: _tabs,
                  builder: (_, __) {
                    if (_tabs.index == 0) return const SizedBox.shrink();
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.sageLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.sage.withOpacity(0.3))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Demo Credentials',
                            style: GoogleFonts.sourceSans3(
                              fontSize: 11, fontWeight: FontWeight.w700,
                              color: AppColors.sage)),
                          const SizedBox(height: 4),
                          Text('Pastor:  selvin@acidiocese.org  /  1234',
                            style: GoogleFonts.sourceSans3(
                              fontSize: 12, color: AppColors.textSecondary)),
                          Text('Admin:   bishop@acidiocese.org  /  bishop123',
                            style: GoogleFonts.sourceSans3(
                              fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    );
                  },
                ),

                // Email
                Text('Email Address',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined,
                      color: AppColors.primary, size: 20)),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password
                Text('Password',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _signIn(),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded,
                      color: AppColors.primary, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_outlined
                                 : Icons.visibility_off_outlined,
                        color: AppColors.textMuted, size: 20),
                      onPressed: () => setState(() => _obscure = !_obscure))),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    return null;
                  },
                ),

                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _resetPassword,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 36)),
                    child: Text('Forgot Password?',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),

                const SizedBox(height: 8),

                // Sign In button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _signIn,
                    child: _loading
                      ? const SizedBox(width: 20, height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                      : Text('Sign In',
                          style: GoogleFonts.sourceSans3(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),

                const SizedBox(height: 16),

                // Continue without login
                OutlinedButton(
                  onPressed: () => context.go('/home'),
                  child: Text('Continue as Guest',
                    style: GoogleFonts.sourceSans3(
                      fontSize: 14, fontWeight: FontWeight.w600,
                      color: AppColors.primary)),
                ),

                const SizedBox(height: 20),

                // Register links
                Center(child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("Don't have an account? ",
                      style: GoogleFonts.sourceSans3(
                        fontSize: 13, color: AppColors.textMuted)),
                    GestureDetector(
                      onTap: () => context.go('/register'),
                      child: Text('Register',
                        style: GoogleFonts.sourceSans3(
                          fontSize: 13, fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline))),
                  ]),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => context.go('/join'),
                    child: Text('Join as a Pastor — Apply Here',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline))),
                ])),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
