import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../admin/application_admin_service.dart';

class RegistrationSuccessScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const RegistrationSuccessScreen({super.key, required this.data});

  @override
  State<RegistrationSuccessScreen> createState() => _SuccessState();
}

class _SuccessState extends State<RegistrationSuccessScreen> {
  bool _submitted = false;
  bool _submitError = false;
  int _countdown = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _submit();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _submit() async {
    if (widget.data['payment_status'] != 'PAID') {
      debugPrint('❌ Blocked: payment not completed');
      return;
    }
    try {
      await ApplicationAdminService.submitApplication(widget.data);
      debugPrint('✅ Application submitted successfully');
      if (mounted) setState(() => _submitted = true);
    } catch (e) {
      debugPrint('❌ Submission error: $e');
      if (mounted) setState(() { _submitted = true; _submitError = true; });
    }
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _countdown--);
      if (_countdown <= 0) {
        t.cancel();
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentId = widget.data['payment_id'] as String? ?? '';
    final appId = widget.data['id'] as String? ?? paymentId;
    final name = widget.data['name'] as String? ?? '';
    final timestamp = widget.data['timestamp'] as String? ?? '';

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(children: [
            const SizedBox(height: 40),

            // ── Green check ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.sage.withValues(alpha: 0.15), AppColors.sage.withValues(alpha: 0.05)]),
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(color: AppColors.sageLight, shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, size: 64, color: AppColors.sage),
              ),
            ),
            const SizedBox(height: 28),

            Text('Application Submitted!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text('Thank you${name.isNotEmpty ? ", $name" : ""}',
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),

            // ── Details Card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.sage.withValues(alpha: 0.3)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Confirmation Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.sage)),
                const SizedBox(height: 16),

                _detailRow('Application ID', appId),
                _detailRow('Payment ID', paymentId),
                _detailRow('Amount Paid', '₹ 3,000'),
                _detailRow('Payment Status', 'PAID', valueColor: AppColors.success),
                _detailRow('Payment Mode', widget.data['payment_mode'] as String? ?? ''),
                if (timestamp.isNotEmpty) _detailRow('Date & Time', timestamp),
              ]),
            ),
            const SizedBox(height: 20),

            // ── Sync Status ──
            if (!_submitted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue)),
                  SizedBox(width: 10),
                  Text('Syncing to server…', style: TextStyle(fontSize: 12, color: Colors.blue)),
                ]),
              )
            else if (_submitError)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.warning_rounded, size: 14, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(child: Text('Could not sync. Contact support.', style: TextStyle(fontSize: 12, color: Colors.orange))),
                ]),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(color: AppColors.sage.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.cloud_done_rounded, size: 14, color: AppColors.sage),
                  SizedBox(width: 8),
                  Text('Saved to server ✓', style: TextStyle(fontSize: 12, color: AppColors.sage)),
                ]),
              ),
            const SizedBox(height: 20),

            const Text('Our synod office will review your details and contact you shortly.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.5),
              textAlign: TextAlign.center),
            const SizedBox(height: 28),

            // ── Go Home ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sage, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => context.go('/home'),
                child: Text('Return to Home ($_countdown s)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted))),
        const SizedBox(width: 8),
        Expanded(child: Text(value.isNotEmpty ? value : '—',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.textPrimary))),
      ]),
    );
  }
}
