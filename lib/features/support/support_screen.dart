import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.scaffold, appBar: AppBar(title: const Text('Support')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('How can we help?', style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 16),
        _tile(context, Icons.volunteer_activism_rounded, 'Prayer Request', 'Submit your prayer needs', AppColors.lavenderLighter, AppColors.lavender, '/prayer'),
        _tile(context, Icons.favorite_rounded, 'Donate / Offering', 'Support the ministry', AppColors.blushLight, AppColors.blush, '/donate'),
        _tile(context, Icons.call_rounded, 'Contact Office', 'Reach the diocesan headquarters', AppColors.primaryLighter, AppColors.primary, '/contact'),
        _tile(context, Icons.groups_rounded, 'Join Community', 'Register as a pastor', AppColors.sageLight, AppColors.sage, '/join'),
        const SizedBox(height: 24),
        Text('Frequently Asked Questions', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        _faq(context, 'How do I become a member of ACI Diocese?', 'Click "Join Community" above and fill out the 3-step registration form. Your application will be reviewed by the central office.'),
        _faq(context, 'How do I donate to the diocese?', 'Use the "Donate" option to scan the UPI QR code or open your preferred payment app directly.'),
        _faq(context, 'Who can I contact for enquiries?', 'Reach us at 0451-2480100 or email acidiocese@gmail.com during office hours (Mon-Sat, 9:30 AM - 6:30 PM).'),
        _faq(context, 'How do I submit a prayer request?', 'Go to "Prayer Request", fill in your name and prayer need, and our pastoral team will pray for you.'),
        const SizedBox(height: 40),
      ])));
  }

  Widget _tile(BuildContext context, IconData icon, String title, String sub, Color bg, Color iconColor, String route) {
    return GestureDetector(onTap: () => context.push(route), child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Text(sub, style: Theme.of(context).textTheme.bodySmall),
        ])),
        const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
      ])));
  }

  Widget _faq(BuildContext context, String q, String a) {
    return Container(margin: const EdgeInsets.only(bottom: 8), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: ExpansionTile(title: Text(q, style: Theme.of(context).textTheme.titleSmall), tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16), children: [Text(a, style: Theme.of(context).textTheme.bodyMedium)]));
  }
}
