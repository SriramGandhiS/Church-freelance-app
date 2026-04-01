import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class DonationQRScreen extends StatelessWidget {
  final double amount;
  final String purpose;
  const DonationQRScreen({super.key, required this.amount, required this.purpose});

  String get _upiString => 'upi://pay?pa=${AppStrings.upiId}&pn=${Uri.encodeComponent('ACI Diocese')}&am=${amount.toInt()}&cu=INR&tn=${Uri.encodeComponent(purpose)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.scaffold, appBar: AppBar(title: const Text('Scan to Donate')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [
        Container(padding: const EdgeInsets.all(24), width: double.infinity,
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: QrImageView(data: _upiString, version: QrVersions.auto, size: 180)),
            const SizedBox(height: 20),
            Text('ACI Diocese', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
            Text('UPI: ${AppStrings.upiId}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
            const SizedBox(height: 12),
            Text('\u20b9${amount.toInt()}', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white)),
            const SizedBox(height: 4),
            Text(purpose, style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 16),
            Text('Open GPay \u00b7 PhonePe \u00b7 Paytm and scan', style: TextStyle(color: Colors.white60, fontSize: 11)),
          ])),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
          child: Column(children: [
            _infoRow('METHOD', 'Bank Transfer via UPI'),
            const Divider(height: 20),
            _infoRow('SECURITY', 'NPCI Standard'),
          ])),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: () => launchUrl(Uri.parse(_upiString)),
          child: const Text('Pay via GPay / PhonePe'))),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(
          icon: const Icon(Icons.share_rounded),
          label: const Text('Share QR Details'),
          onPressed: () => Share.share('Donate to ACI Diocese\nUPI: ${AppStrings.upiId}\nAmount: \u20b9${amount.toInt()}\nPurpose: $purpose'))),
        const SizedBox(height: 40),
      ])));
  }

  Widget _infoRow(String label, String value) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(label, style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.6)),
    Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
  ]);
}
