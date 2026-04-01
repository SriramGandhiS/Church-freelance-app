import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _nameCtrl   = TextEditingController();
  final _emailCtrl  = TextEditingController();
  final _phoneCtrl  = TextEditingController();
  final _passCtrl   = TextEditingController();
  final _confCtrl   = TextEditingController();
  bool  _obscure1   = true;
  bool  _obscure2   = true;
  bool  _loading    = false;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _passCtrl.dispose(); _confCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );
      await FirebaseFirestore.instance
        .collection('users').doc(cred.user!.uid).set({
        'uid':       cred.user!.uid,
        'name':      _nameCtrl.text.trim(),
        'email':     _emailCtrl.text.trim(),
        'phone':     _phoneCtrl.text.trim(),
        'role':      'user',
        'photoUrl':  '',
        'createdAt': FieldValue.serverTimestamp(),
        'isActive':  true,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Welcome.'),
          backgroundColor: AppColors.success));
      context.go('/home');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String msg;
      switch (e.code) {
        case 'email-already-in-use': msg = 'An account with this email already exists.'; break;
        case 'weak-password':        msg = 'Password must be at least 6 characters.'; break;
        case 'invalid-email':        msg = 'Please enter a valid email address.'; break;
        case 'internal-error':       msg = 'FIREBASE ERROR: Please enable "Email/Password" sign-in provider in your Firebase Console.'; break;
        default: msg = e.message ?? 'Registration failed. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: AppColors.error));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration error. Please check your connection and try again.'), backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Full Name
              _fieldLabel('Full Name'),
              TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Your full name',
                  prefixIcon: Icon(Icons.person_outline_rounded,
                    color: AppColors.primary, size: 20)),
                validator: (v) => (v?.trim().isEmpty ?? true)
                  ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),

              // Email
              _fieldLabel('Email Address'),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'your@email.com',
                  prefixIcon: Icon(Icons.email_outlined,
                    color: AppColors.primary, size: 20)),
                validator: (v) {
                  if (v?.trim().isEmpty ?? true) return 'Email is required';
                  if (!v!.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone
              _fieldLabel('Mobile Number'),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '9xxxxxxxxx',
                  prefixIcon: Icon(Icons.phone_outlined,
                    color: AppColors.primary, size: 20)),
                validator: (v) {
                  if (v?.trim().isEmpty ?? true) return 'Mobile number is required';
                  if (v!.trim().length < 10) return 'Enter a valid 10-digit number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password
              _fieldLabel('Password'),
              TextFormField(
                controller: _passCtrl,
                obscureText: _obscure1,
                decoration: InputDecoration(
                  hintText: 'Minimum 6 characters',
                  prefixIcon: const Icon(Icons.lock_outline_rounded,
                    color: AppColors.primary, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure1 ? Icons.visibility_outlined
                               : Icons.visibility_off_outlined,
                      color: AppColors.textMuted, size: 20),
                    onPressed: () => setState(() => _obscure1 = !_obscure1))),
                validator: (v) {
                  if (v?.isEmpty ?? true) return 'Password is required';
                  if (v!.length < 6) return 'At least 6 characters required';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm Password
              _fieldLabel('Confirm Password'),
              TextFormField(
                controller: _confCtrl,
                obscureText: _obscure2,
                decoration: InputDecoration(
                  hintText: 'Re-enter password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded,
                    color: AppColors.primary, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure2 ? Icons.visibility_outlined
                               : Icons.visibility_off_outlined,
                      color: AppColors.textMuted, size: 20),
                    onPressed: () => setState(() => _obscure2 = !_obscure2))),
                validator: (v) {
                  if (v?.isEmpty ?? true) return 'Please confirm your password';
                  if (v != _passCtrl.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 28),

              // Register button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading ? null : _register,
                  child: _loading
                    ? const SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                    : Text('Create Account',
                        style: GoogleFonts.sourceSans3(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),

              const SizedBox(height: 16),
              Center(child: GestureDetector(
                onTap: () => context.go('/login'),
                child: RichText(text: TextSpan(children: [
                  TextSpan(text: 'Already have an account? ',
                    style: GoogleFonts.sourceSans3(
                      fontSize: 13, color: AppColors.textMuted)),
                  TextSpan(text: 'Sign In',
                    style: GoogleFonts.sourceSans3(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline)),
                ])),
              )),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: GoogleFonts.sourceSans3(
      fontSize: 13, fontWeight: FontWeight.w600,
      color: AppColors.textSecondary)));
}
