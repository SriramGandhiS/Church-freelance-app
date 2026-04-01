import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';

class UpdateCard extends StatefulWidget {
  final String title;
  final String body;
  final Timestamp date;
  final bool isImportant;

  const UpdateCard({super.key, required this.title, required this.body, required this.date, this.isImportant = false});

  @override
  State<UpdateCard> createState() => _UpdateCardState();
}

class _UpdateCardState extends State<UpdateCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            if (widget.isImportant) ...[
              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.errorLight, borderRadius: BorderRadius.circular(20)),
                child: Text('IMPORTANT', style: TextStyle(color: AppColors.error, fontSize: 10, fontWeight: FontWeight.bold))),
              const SizedBox(width: 8),
            ],
            Text(DateFormat('MMM dd, yyyy').format(widget.date.toDate()), style: Theme.of(context).textTheme.bodySmall),
          ]),
          const SizedBox(height: 8),
          Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(widget.body, style: Theme.of(context).textTheme.bodyMedium, maxLines: _expanded ? null : 2, overflow: _expanded ? null : TextOverflow.ellipsis),
        ]),
      ),
    );
  }
}
