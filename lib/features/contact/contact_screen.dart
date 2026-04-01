import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: const Text('Contact Us'), centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.canPop() ? context.pop() : context.go('/home'))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.primary, AppColors.lavender]), borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.location_on_rounded, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            const Text('Central Diocesan Office', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(AppStrings.address, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
          ])),
        const SizedBox(height: 16),
        _card(context, Icons.phone_rounded, 'Telephone', AppStrings.phone, AppColors.sage, () => launchUrl(Uri.parse('tel:${AppStrings.phone}'))),
        _card(context, Icons.email_rounded, 'Email', AppStrings.email, AppColors.primary, () => launchUrl(Uri.parse('mailto:${AppStrings.email}'))),
        _card(context, Icons.language_rounded, 'Website', AppStrings.website, AppColors.lavender, () => launchUrl(Uri.parse('https://${AppStrings.website}'), mode: LaunchMode.externalApplication)),
        _card(context, Icons.access_time_rounded, 'Office Hours', AppStrings.officeHours, AppColors.blush, null),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: ElevatedButton.icon(
          icon: const Icon(Icons.directions_rounded),
          label: const Text('Get Directions on Google Maps'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          onPressed: () => launchUrl(Uri.parse(AppStrings.mapsUrl), mode: LaunchMode.externalApplication),
        )),
      ])),
    );
  }

  Widget _card(BuildContext ctx, IconData icon, String label, String value, Color color, VoidCallback? onTap) =>
    GestureDetector(onTap: onTap, child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(children: [CircleAvatar(radius: 20, backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color, size: 18)), const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)), Text(value, style: const TextStyle(fontSize: 14))]))])));
}
