import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/launcher_helper.dart';

class ChurchDetailScreen extends ConsumerWidget {
  final String churchId;
  const ChurchDetailScreen({super.key, required this.churchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(churchId),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
          .collection('churches').doc(churchId).snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || !snap.data!.exists) {
            return Center(child: Text('Church not found: $churchId'));
          }
          final c = snap.data!.data() as Map<String, dynamic>;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Church header card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLighter,
                    borderRadius: BorderRadius.circular(16)),
                  child: Column(children: [
                    ClipOval(
                      child: Image.asset('assets/images/aci_logo.png',
                        width: 64, height: 64, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.church_rounded,
                          size: 32, color: AppColors.primary))),
                    const SizedBox(height: 10),
                    Text(c['churchName'] ?? '',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.merriweather(
                        fontSize: 18, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      _chip('ID: ${c['churchId'] ?? ''}', AppColors.primary, AppColors.primaryLighter),
                      const SizedBox(width: 8),
                      _chip(c['zoneName'] ?? '', AppColors.lavender, AppColors.lavenderLighter),
                    ]),
                  ]),
                ),
                const SizedBox(height: 16),

                // Church and Pastor Registry details (from Excel)
                _detailCard('Directory Information', [
                  _row(Icons.badge_rounded,           'Reg.No',            c['churchId'] ?? ''),
                  _row(Icons.person_rounded,          'Name',              c['pastorName'] ?? ''),
                  _row(Icons.work_outline_rounded,    'Designation',       c['designation'] ?? ''),
                  _row(Icons.cake_rounded,            'D.O.B',             c['pastorDob'] ?? ''),
                  _row(Icons.home_rounded,            'Contact Address',   c['address'] ?? ''),
                  _row(Icons.church_rounded,          'Church Name',       c['churchName'] ?? ''),
                  _row(Icons.location_on_rounded,     'District',          c['districtName'] ?? ''),
                  _row(Icons.phone_rounded,           'Phone No.',         c['pastorPhone'] ?? ''),
                  _row(Icons.calendar_today_rounded,  'Date of Ordination',c['dateOfOrdination'] ?? ''),
                  _row(Icons.info_outline_rounded,    'Status',            c['status'] ?? (c['isActive'] == true ? 'Active' : '')),
                ]),

                const SizedBox(height: 12),

                // Diocese / Bishop
                _detailCard('Diocese Details', [
                  _row(Icons.account_balance_rounded, 'Diocese',      'Apostolic Council of India Diocese'),
                  _row(Icons.stars_rounded,           'Bishop',       c['headBishopName'] ?? ''),
                  _row(Icons.verified_rounded,        'Registered',   'Indian Trust Act 1882 · Reg. No 62/B.k.4/2013'),
                ]),

                const SizedBox(height: 16),

                // Call pastor button
                if ((c['pastorPhone'] ?? '').toString().isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () => LauncherHelper.callPhone(c['pastorPhone']),
                    icon: const Icon(Icons.call_rounded),
                    label: Text('Call Pastor: ${c['pastorPhone']}'),
                  ),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _chip(String label, Color text, Color bg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: GoogleFonts.sourceSans3(
      fontSize: 11, fontWeight: FontWeight.w700, color: text)));

  Widget _detailCard(String title, List<Widget> rows) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: GoogleFonts.merriweather(
        fontSize: 15, fontWeight: FontWeight.w700,
        color: AppColors.textPrimary)),
      const SizedBox(height: 10),
      const Divider(height: 1),
      const SizedBox(height: 8),
      ...rows,
    ]));

  Widget _row(IconData icon, String label, String value) {
    if (value.isEmpty || value == '0') return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 10),
        SizedBox(width: 110, child: Text(label,
          style: GoogleFonts.sourceSans3(
            fontSize: 12, fontWeight: FontWeight.w600,
            color: AppColors.textMuted))),
        Expanded(child: Text(value,
          style: GoogleFonts.sourceSans3(
            fontSize: 13, color: AppColors.textPrimary))),
      ]));
  }
}
