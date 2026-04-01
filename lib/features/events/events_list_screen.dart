import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class EventsListScreen extends StatelessWidget {
  const EventsListScreen({super.key});

  static const _events = [
    {'id': 'big-mass', 'title': 'Holy Communion Service — Big Mass 2026', 'tag': 'BIG MASS 2026', 'date': 'April 15, 2026', 'time': '10:00 AM', 'location': 'Central Diocesan Office, Hanumantharayan Kottai, Dindigul', 'desc': 'Annual Holy Communion and worship service for all members of ACI Diocese. All pastors and congregation members are warmly invited.', 'active': true},
    {'id': 'synod-meeting', 'title': 'Annual Synod Meeting 2026', 'tag': 'SYNOD 2026', 'date': 'May 20, 2026', 'time': '9:00 AM', 'location': 'Diocesan Office, Dindigul', 'desc': 'Annual general body meeting of Synod bishops and overseers. Mandatory attendance for ordained pastors.', 'active': true},
    {'id': 'ordination', 'title': 'Ordination Service 2026', 'tag': 'ORDINATION', 'date': 'June 10, 2026', 'time': '10:30 AM', 'location': 'Central Diocesan Office, Dindigul', 'desc': 'Sacred ordination ceremony for new pastors and deacons.', 'active': true},
    {'id': 'pastors-fellowship', 'title': 'Quarterly Pastors Fellowship', 'tag': 'FELLOWSHIP', 'date': 'July 5, 2026', 'time': '10:00 AM', 'location': 'Central Office, Dindigul', 'desc': 'Quarterly fellowship and prayer meeting for all registered pastors.', 'active': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: const Text('Events'), centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.canPop() ? context.pop() : context.go('/home'))),
      body: ListView.builder(padding: const EdgeInsets.all(16), itemCount: _events.length, itemBuilder: (_, i) {
        final e = _events[i];
        return GestureDetector(onTap: () => context.push('/events/${e['id']}'),
          child: Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                  child: Text(e['tag'] as String, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                const Spacer(),
                if (e['active'] == true) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(3)),
                  child: const Text('OPEN', style: TextStyle(color: AppColors.sage, fontSize: 9, fontWeight: FontWeight.bold))),
              ]),
              const SizedBox(height: 10),
              Text(e['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Row(children: [const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textMuted), const SizedBox(width: 6), Text('${e['date']} · ${e['time']}', style: TextStyle(fontSize: 13, color: AppColors.textSecondary))]),
              const SizedBox(height: 4),
              Row(children: [const Icon(Icons.location_on_rounded, size: 14, color: AppColors.textMuted), const SizedBox(width: 6), Expanded(child: Text(e['location'] as String, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)))]),
              const SizedBox(height: 8),
              Text(e['desc'] as String, style: TextStyle(fontSize: 13, color: AppColors.textMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
            ])));
      }),
    );
  }
}
