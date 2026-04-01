import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class AdminAddEventScreen extends StatefulWidget {
  const AdminAddEventScreen({super.key});
  @override
  State<AdminAddEventScreen> createState() => _AdminAddEventScreenState();
}

class _AdminAddEventScreenState extends State<AdminAddEventScreen> {
  final _titleCtrl = TextEditingController(); final _tagCtrl = TextEditingController();
  final _locationCtrl = TextEditingController(); final _descCtrl = TextEditingController();
  DateTime? _date; TimeOfDay? _time; bool _isLoading = false;

  Future<void> _submit() async {
    if (_titleCtrl.text.isEmpty || _date == null || _time == null) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill all required fields.'))); return; }
    setState(() => _isLoading = true);
    try {
      final dt = DateTime(_date!.year, _date!.month, _date!.day, _time!.hour, _time!.minute);
      await FirebaseFirestore.instance.collection('events').add({'title': _titleCtrl.text.trim(), 'tag': _tagCtrl.text.trim().toUpperCase(),
        'location': _locationCtrl.text.trim(), 'description': _descCtrl.text.trim(), 'date': Timestamp.fromDate(dt), 'isActive': true, 'registrationOpen': true});
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event Added!'), backgroundColor: AppColors.success)); context.pop(); }
    } catch (_) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed.'), backgroundColor: AppColors.error)); }
    finally { if (mounted) setState(() => _isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.scaffold, appBar: AppBar(title: const Text('Create New Event')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Event Title *', prefixIcon: Icon(Icons.title_rounded))),
        const SizedBox(height: 16), TextField(controller: _tagCtrl, decoration: const InputDecoration(labelText: 'Category Tag', prefixIcon: Icon(Icons.label_rounded))),
        const SizedBox(height: 16), TextField(controller: _locationCtrl, decoration: const InputDecoration(labelText: 'Location', prefixIcon: Icon(Icons.location_on_rounded))),
        const SizedBox(height: 16), TextField(controller: _descCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Details', alignLabelWithHint: true)),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(child: OutlinedButton.icon(onPressed: () async { final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030)); if (d != null) setState(() => _date = d); },
            icon: const Icon(Icons.calendar_today_rounded), label: Text(_date == null ? 'Date *' : '${_date!.day}/${_date!.month}/${_date!.year}'))),
          const SizedBox(width: 12),
          Expanded(child: OutlinedButton.icon(onPressed: () async { final t = await showTimePicker(context: context, initialTime: TimeOfDay.now()); if (t != null) setState(() => _time = t); },
            icon: const Icon(Icons.access_time_rounded), label: Text(_time == null ? 'Time *' : _time!.format(context)))),
        ]),
        const SizedBox(height: 48),
        ElevatedButton(onPressed: _isLoading ? null : _submit,
          child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Publish Event')),
      ])));
  }
}
