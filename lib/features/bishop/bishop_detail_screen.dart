import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class BishopDetailScreen extends StatelessWidget {
  const BishopDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('Bishop & Founder'),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.canPop() ? context.pop() : context.go('/home')),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.blush, AppColors.lavender], begin: Alignment.topLeft, end: Alignment.bottomRight)),
            child: Column(children: [
              CircleAvatar(radius: 52, backgroundColor: Colors.white.withValues(alpha: 0.25),
                child: const Text('JD', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white))),
              const SizedBox(height: 16),
              const Text('Rt. Rev. Johnson Durai S.', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                child: const Text('Bishop & Founder · ACI Diocese', style: TextStyle(color: Colors.white, fontSize: 12))),
              const SizedBox(height: 8),
              const Text('Ministry: Power in the Word Ministries', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ]),
          ),

          Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Verse card
            Container(padding: const EdgeInsets.all(16), margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: AppColors.lavenderLighter, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.lavenderLight)),
              child: Column(children: [
                const Icon(Icons.format_quote_rounded, color: AppColors.lavender, size: 28),
                const SizedBox(height: 8),
                const Text('"And I will set up one shepherd over them, and he shall feed them, even my servant David; he shall feed them, and he shall be their shepherd."', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14, height: 1.6), textAlign: TextAlign.center),
                const SizedBox(height: 6),
                const Text('— Ezekiel 34:23', style: TextStyle(color: AppColors.lavender, fontWeight: FontWeight.bold, fontSize: 13)),
              ])),

            const Text('Biography', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            Text(AppStrings.bishopBio, style: const TextStyle(fontSize: 14, height: 1.8, color: AppColors.textSecondary)),
            const SizedBox(height: 24),

            // Stats row
            Row(children: [
              _stat('25+', 'Years in Ministry'),
              _stat('15+', 'Pastors Ordained'),
              _stat('2013', 'Diocese Founded'),
            ]),
            const SizedBox(height: 24),

            // Contact buttons
            const Text('Contact', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _contactBtn(context, Icons.phone_rounded, 'Call Office: ${AppStrings.phone}', () => launchUrl(Uri.parse('tel:${AppStrings.phone}'))),
            const SizedBox(height: 8),
            _contactBtn(context, Icons.email_rounded, AppStrings.email, () => launchUrl(Uri.parse('mailto:${AppStrings.email}'))),
            const SizedBox(height: 8),
            _contactBtn(context, Icons.language_rounded, AppStrings.website, () => launchUrl(Uri.parse('https://${AppStrings.website}'), mode: LaunchMode.externalApplication)),
            const SizedBox(height: 24),

            SizedBox(width: double.infinity, child: ElevatedButton.icon(
              icon: const Icon(Icons.volunteer_activism_rounded),
              label: const Text('Send Prayer Request'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () => context.push('/prayer'),
            )),
          ])),
        ]),
      ),
    );
  }

  Widget _stat(String value, String label) => Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 4), padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
    child: Column(children: [Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)), const SizedBox(height: 4), Text(label, style: TextStyle(fontSize: 10, color: AppColors.textMuted), textAlign: TextAlign.center)])));

  Widget _contactBtn(BuildContext ctx, IconData icon, String label, VoidCallback onTap) =>
    GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(children: [Icon(icon, color: AppColors.primary, size: 20), const SizedBox(width: 12), Text(label, style: const TextStyle(fontSize: 13))])));
}
