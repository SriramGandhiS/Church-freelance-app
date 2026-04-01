import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';

class EventCard extends StatelessWidget {
  final String id;
  final String title;
  final String tag;
  final Timestamp date;
  final String location;

  const EventCard({super.key, required this.id, required this.title, required this.tag, required this.date, required this.location});

  @override
  Widget build(BuildContext context) {
    final dt = date.toDate();
    return GestureDetector(
      onTap: () => context.push('/events/$id'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (tag.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.primaryLighter, borderRadius: BorderRadius.circular(20)),
              child: Text(tag, style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          if (tag.isNotEmpty) const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.headlineSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Row(children: [
            Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(DateFormat('MMM dd, yyyy \u00b7 hh:mm a').format(dt), style: Theme.of(context).textTheme.bodySmall),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.location_on_rounded, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 6),
            Expanded(child: Text(location, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.push('/events/$id'),
              child: Text('View Details \u2192', style: TextStyle(color: AppColors.primary, fontSize: 13)),
            ),
          ),
        ]),
      ),
    );
  }
}
