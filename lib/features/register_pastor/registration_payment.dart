import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import '../../core/constants/app_colors.dart';

class RegistrationPaymentScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const RegistrationPaymentScreen({super.key, required this.data});

  @override
  State<RegistrationPaymentScreen> createState() => _RegPayState();
}

class _RegPayState extends State<RegistrationPaymentScreen> {
  bool _loading = false;

  // ── UPI Configuration ──
  static const String _upiId = 'acidiocese@okaxis'; // Replace with real UPI ID
  static const String _payeeName = 'ACI Diocese';
  static const double _amount = 3000.00;

  // ── Real UPI Payment via Explicit App Chooser ──
  void _showUpiChooser() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Select UPI App', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            const Text('Choose an app to complete the transaction', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _upiAppBtn(ctx, 'GPay', Icons.g_mobiledata_rounded, Colors.blue, 'gpay', 'gpay://upi/pay'),
              _upiAppBtn(ctx, 'PhonePe', Icons.phone_android_rounded, Colors.purple, 'phonepe', 'phonepe://pay'),
              _upiAppBtn(ctx, 'Paytm', Icons.payments_rounded, Colors.lightBlue, 'paytm', 'paytmmp://pay'),
              _upiAppBtn(ctx, 'Other', Icons.apps_rounded, AppColors.sage, 'other', 'upi://pay'),
            ]),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }

  Widget _upiAppBtn(BuildContext ctx, String name, IconData ic, Color c, String modeId, String scheme) {
    return GestureDetector(
      onTap: () { Navigator.pop(ctx); _launchUpi(scheme, modeId); },
      child: Column(children: [
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(color: c.withValues(alpha: 0.1), shape: BoxShape.circle, border: Border.all(color: c.withValues(alpha: 0.3))),
          child: Icon(ic, color: c, size: 32),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Future<void> _launchUpi(String scheme, String modeId) async {
    setState(() => _loading = true);
    final txnRef = 'ACI${DateTime.now().millisecondsSinceEpoch}';

    // Some apps require specific parameter order or simply scheme://pay?
    final urlStr = '$scheme?pa=$_upiId&pn=${Uri.encodeComponent(_payeeName)}'
        '&am=$_amount&cu=INR&tn=${Uri.encodeComponent("ACI Diocese Registration Fee")}'
        '&tr=$txnRef';
        
    final upiUrl = Uri.parse(urlStr);

    try {
      final launched = await launchUrl(upiUrl, mode: LaunchMode.externalNonBrowserApplication);
      if (!launched) {
        if (mounted) {
          setState(() => _loading = false);
          _showError('Could not open this app. It might not be installed.');
        }
        return;
      }
      
      // Successfully launched external app. Show confirmation dialog when user returns.
      if (mounted) {
        setState(() => _loading = false);
        _showPaymentConfirmation(txnRef, modeId);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        _showError('Error launching app: $e');
      }
    }
  }

  // ── After UPI redirect, ask user to confirm ──
  void _showPaymentConfirmation(String txnRef, String modeId) {
    showDialog(
      context: context, barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.check_circle_outline_rounded, color: AppColors.sage, size: 28),
          SizedBox(width: 10),
          Expanded(child: Text('Payment Completed?', style: TextStyle(fontSize: 16))),
        ]),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Did you complete the payment in your UPI app?',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.scaffold, borderRadius: BorderRadius.circular(10)),
            child: Column(children: [
              _miniRow('Ref', txnRef),
              _miniRow('Amount', '₹ 3,000'),
              _miniRow('To', _payeeName),
            ]),
          ),
        ]),
        actions: [
          TextButton(
            onPressed: () { Navigator.pop(ctx); _showError('Payment cancelled. Please try again.'); },
            child: const Text('No, Failed', style: TextStyle(color: AppColors.error)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.sage),
            onPressed: () {
              Navigator.pop(ctx);
              _navigateToSuccess(txnRef, 'UPI ($modeId)');
            },
            child: const Text('Yes, Paid ✓', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── TEST MODE (Bypass) ──
  Future<void> _processTestMode() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    final r = Random();
    final txnId = 'TEST_${r.nextInt(900000) + 100000}${String.fromCharCode(r.nextInt(26) + 65)}';

    if (mounted) {
      setState(() => _loading = false);
      _navigateToSuccess(txnId, 'TEST BYPASS');
    }
  }

  // ── Navigate to success ──
  void _navigateToSuccess(String paymentId, String paymentMode) {
    final now = DateTime.now();
    final timestamp = '${now.day.toString().padLeft(2, '0')}-${_monthName(now.month)}-${now.year} ${_fmtTime(now)}';

    final payload = {
      ...widget.data,
      'payment_id': paymentId,
      'payment_status': 'PAID',
      'payment_mode': paymentMode,
      'timestamp': timestamp,
    };

    context.go('/join/success', extra: payload);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg), backgroundColor: AppColors.error,
      duration: const Duration(seconds: 4)));
  }

  String _monthName(int m) => const ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m - 1];
  String _fmtTime(DateTime d) {
    final h = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
    return '$h:${d.minute.toString().padLeft(2, '0')} ${d.hour >= 12 ? 'PM' : 'AM'}';
  }

  Widget _miniRow(String l, String v) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(l, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
      Text(v, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    ]),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('Registration Payment'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Progress
          Row(children: List.generate(4, (i) => Expanded(
            child: Container(height: 5, margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(color: AppColors.sage, borderRadius: BorderRadius.circular(3))),
          ))),
          const SizedBox(height: 24),

          const Text('Registration Fee', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Fee Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface, borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.sage.withValues(alpha: 0.3)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
            ),
            child: Column(children: [
              const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Text('ACI Diocese Registration', style: TextStyle(color: AppColors.textSecondary, fontSize: 13))),
                Text('₹ 3,000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ]),
              const SizedBox(height: 12),
              const Divider(color: AppColors.divider),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('₹ 3,000', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.sage)),
              ]),
            ]),
          ),
          const SizedBox(height: 24),

          // UPI Info
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.primaryLighter, borderRadius: BorderRadius.circular(12)),
            child: const Row(children: [
              Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 18),
              SizedBox(width: 10),
              Expanded(child: Text(
                'Clicking "Pay" will open your UPI app (Google Pay, PhonePe, etc.) to complete the payment.',
                style: TextStyle(fontSize: 12, color: AppColors.primary, height: 1.4))),
            ]),
          ),
          const SizedBox(height: 28),

          // Pay Button
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sage, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 2),
              icon: _loading ? const SizedBox.shrink() : const Icon(Icons.payment_rounded),
              label: _loading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Pay ₹3,000 via UPI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              onPressed: _loading ? null : _showUpiChooser,
            ),
          ),
          const SizedBox(height: 14),

          // TEST MODE
          SizedBox(
            width: double.infinity, height: 44,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange, side: const BorderSide(color: Colors.orange, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              onPressed: _loading ? null : _processTestMode,
              child: const Text('⚠️ TEST MODE (Bypass Payment)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
          const Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.lock_rounded, size: 13, color: AppColors.textMuted),
            SizedBox(width: 5),
            Text('Secure payment', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ])),
        ]),
      ),
    );
  }
}
