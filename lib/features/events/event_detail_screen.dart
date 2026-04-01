import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  static const _allEvents = {
    'big-mass': {'title': 'Holy Communion Service — Big Mass 2026', 'tag': 'BIG MASS 2026', 'date': 'April 15, 2026', 'time': '10:00 AM', 'location': 'Central Diocesan Office, Hanumantharayan Kottai, Dindigul', 'desc': 'Annual Holy Communion and worship service for all members of ACI Diocese. All pastors and congregation members are warmly invited to attend and participate in this sacred gathering.\n\nSchedule:\n• 9:30 AM — Registration & Fellowship\n• 10:00 AM — Praise & Worship\n• 11:00 AM — Bishop\'s Message\n• 12:00 PM — Holy Communion\n• 1:00 PM — Fellowship Meal'},
    'synod-meeting': {'title': 'Annual Synod Meeting 2026', 'tag': 'SYNOD 2026', 'date': 'May 20, 2026', 'time': '9:00 AM', 'location': 'Diocesan Office, Dindigul', 'desc': 'Annual general body meeting of all Synod bishops and district overseers. Attendance is mandatory for all ordained pastors.\n\nAgenda:\n• Reports from all dioceses\n• Financial review\n• New ordination approvals\n• Ministry planning for 2026–2027'},
    'ordination': {'title': 'Ordination Service 2026', 'tag': 'ORDINATION', 'date': 'June 10, 2026', 'time': '10:30 AM', 'location': 'Central Diocesan Office, Dindigul', 'desc': 'Sacred ordination ceremony for new pastors and deacons entering the ministry of ACI Diocese.\n\nThis is a solemn and spiritual ceremony led by Bishop Rt. Rev. Johnson Durai S.'},
    'pastors-fellowship': {'title': 'Quarterly Pastors Fellowship', 'tag': 'FELLOWSHIP', 'date': 'July 5, 2026', 'time': '10:00 AM', 'location': 'Central Office, Dindigul', 'desc': 'Quarterly fellowship and prayer meeting for all registered pastors of ACI Diocese.\n\nTime of renewal, prayer, and brotherly fellowship.'},
  };

  @override
  Widget build(BuildContext context) {
    final e = _allEvents[eventId] ?? _allEvents.values.first;
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: const Text('Event Details'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop())),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: double.infinity, padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary, AppColors.lavender]), borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)),
              child: Text(e['tag']!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
            const SizedBox(height: 12),
            Text(e['title']!, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ])),
        const SizedBox(height: 16),
        _infoRow(Icons.calendar_today_rounded, 'Date', e['date']!),
        _infoRow(Icons.access_time_rounded, 'Time', e['time']!),
        _infoRow(Icons.location_on_rounded, 'Venue', e['location']!),
        const SizedBox(height: 16),
        Text('About this Event', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Text(e['desc']!, style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.textSecondary)),
        const SizedBox(height: 24),
        Container(
          width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(color: AppColors.lavenderLighter, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.lavender)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(Icons.info_outline_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Meeting Scheduled', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
          ]),
        ),
      ])),
    );
  }
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [
      Icon(icon, size: 18, color: AppColors.primary), const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
        Text(value, style: const TextStyle(fontSize: 14)),
      ]),
    ]));
  }
}
