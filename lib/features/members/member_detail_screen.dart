import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';

class MemberDetailScreen extends StatelessWidget {
  final String pastorId;
  const MemberDetailScreen({super.key, required this.pastorId});

  static const _data = {
    'selvin': {'name': 'Pr. Selvin Durai', 'role': 'District Overseer', 'region': 'Dindigul Central', 'phone': '9944107042', 'email': 'selvin@acidiocese.org', 'church': 'Grace Church, Dindigul', 'init': 'SD'},
    'david': {'name': 'Pr. David Durai', 'role': 'Senior Minister', 'region': 'Dindigul North', 'phone': '9876543210', 'email': 'david@acidiocese.org', 'church': 'Bethel Church, Dindigul', 'init': 'DD'},
    'thaaveethu': {'name': 'Pr. Y. Thaaveethu', 'role': 'Senior Minister', 'region': 'Vadipatti', 'phone': '9876500013', 'email': '', 'church': 'Zion Church, Vadipatti', 'init': 'YT'},
    'baby_thomas': {'name': 'Pr. Baby Thomas', 'role': 'Committee Member', 'region': 'Dindigul South', 'phone': '9876500001', 'email': '', 'church': 'New Life Church, Dindigul', 'init': 'BT'},
    'victor': {'name': 'Pr. Victor Joseph', 'role': 'Committee Member', 'region': 'Palani', 'phone': '9876500005', 'email': '', 'church': 'Living Word Church, Palani', 'init': 'VJ'},
    'solomon': {'name': 'Pr. Solomon Kennedy', 'role': 'Committee Member', 'region': 'Kodaikanal', 'phone': '9876500011', 'email': '', 'church': 'Faith Church, Kodaikanal', 'init': 'SK'},
    'ms_john': {'name': 'Pr. M. S. John Rathina Singh', 'role': 'District Overseer', 'region': 'Madurai', 'phone': '9876500008', 'email': '', 'church': 'Calvary Church, Madurai', 'init': 'MJ'},
  };

  @override
  Widget build(BuildContext context) {
    final p = _data[pastorId] ?? {'name': 'Pastor', 'role': 'Minister', 'region': 'Diocese', 'phone': '', 'email': '', 'church': '', 'init': '?'};
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: const Text('Pastor Profile'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop())),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
        const SizedBox(height: 16),
        CircleAvatar(radius: 50, backgroundColor: AppColors.primaryLight,
          child: Text(p['init']!, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary))),
        const SizedBox(height: 16),
        Text(p['name']!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryLighter, borderRadius: BorderRadius.circular(20)),
          child: Text(p['role']!, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13))),
        const SizedBox(height: 24),
        _card('Region', p['region']!, Icons.map_rounded),
        _card('Church', p['church']!, Icons.church_rounded),
        if (p['phone']!.isNotEmpty) GestureDetector(onTap: () => launchUrl(Uri.parse('tel:${p['phone']}')), child: _card('Phone', p['phone']!, Icons.phone_rounded)),
        if (p['email']!.isNotEmpty) _card('Email', p['email']!, Icons.email_rounded),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(icon: const Icon(Icons.volunteer_activism_rounded), label: const Text('Send Prayer Request'),
          onPressed: () => context.push('/prayer'))),
      ])),
    );
  }
  Widget _card(String label, String value, IconData icon) {
    return Container(width: double.infinity, margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(children: [Icon(icon, size: 20, color: AppColors.primary), const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontSize: 14)),
        ]),
      ]));
  }
}
