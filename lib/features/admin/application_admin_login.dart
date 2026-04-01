import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import 'admin_credentials.dart';

class ApplicationAdminLoginScreen extends StatefulWidget {
  const ApplicationAdminLoginScreen({super.key});

  @override
  State<ApplicationAdminLoginScreen> createState() =>
      _ApplicationAdminLoginScreenState();
}

class _ApplicationAdminLoginScreenState
    extends State<ApplicationAdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _idCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });

    // Simulate async check
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      // FIX 4 — use context.go (not push) for top-level route; .trim() handled inside AdminCredentials.verify
      if (AdminCredentials.verify(_idCtrl.text, _pwCtrl.text)) {
        context.go('/app-admin');
      } else {
        setState(() { _error = 'Invalid ID or Password. Please try again.'; _loading = false; });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('Admin Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Header
                Center(
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLighter,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: const Icon(Icons.admin_panel_settings_rounded,
                        color: AppColors.primary, size: 42),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Admin Access',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'Sign in to manage application registrations',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 36),

                // Error banner
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
                    ),
                    child: Row(children: [
                      const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 13))),
                    ]),
                  ),
                  const SizedBox(height: 20),
                ],

                // Admin ID
                _fieldLabel('Admin ID'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _idCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDeco('Enter admin ID', Icons.badge_rounded),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Password
                _fieldLabel('Password'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _pwCtrl,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _login(),
                  decoration: _inputDeco('Enter password', Icons.lock_rounded).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                          color: AppColors.textMuted, size: 20),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 32),

                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 1,
                    ),
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? const SizedBox(
                            width: 22, height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.login_rounded, size: 20),
                              SizedBox(width: 8),
                              Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) => Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
      );

  InputDecoration _inputDeco(String hint, IconData icon) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textHint),
        prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      );
}
