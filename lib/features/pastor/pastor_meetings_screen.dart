import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class PastorMeetingsScreen extends StatelessWidget {
  const PastorMeetingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.scaffold, appBar: AppBar(title: const Text('Synod Meetings')),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.primaryLighter, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.primary)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(4)),
              child: const Text('UPCOMING', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
            const SizedBox(height: 12),
            Text('Monthly Synod Review', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textMuted), const SizedBox(width: 8),
              Text('April 10, 2026 \u00b7 10:00 AM', style: Theme.of(context).textTheme.bodyMedium)]),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => launchUrl(Uri.parse('https://zoom.us/join')), child: const Text('Join Zoom Meeting'))),
          ])),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Quarterly Pastors Fellowship', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textMuted), const SizedBox(width: 8),
              Text('May 20, 2026 \u00b7 9:00 AM', style: Theme.of(context).textTheme.bodyMedium)]),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.location_on_rounded, size: 14, color: AppColors.textMuted), const SizedBox(width: 8),
              Text('Central Office, Dindigul', style: Theme.of(context).textTheme.bodySmall)]),
          ])),
      ]));
  }
}
