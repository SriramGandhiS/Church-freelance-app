import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class AdminAddUpdateScreen extends StatefulWidget {
  const AdminAddUpdateScreen({super.key});
  @override
  State<AdminAddUpdateScreen> createState() => _AdminAddUpdateScreenState();
}

class _AdminAddUpdateScreenState extends State<AdminAddUpdateScreen> {
  final _titleCtrl = TextEditingController(); final _bodyCtrl = TextEditingController();
  bool _isImportant = false; bool _isLoading = false;

  Future<void> _submit() async {
    if (_titleCtrl.text.isEmpty || _bodyCtrl.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('updates').add({'title': _titleCtrl.text.trim(), 'body': _bodyCtrl.text.trim(), 'date': FieldValue.serverTimestamp(), 'isImportant': _isImportant});
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Update Posted!'), backgroundColor: AppColors.success)); context.pop(); }
    } catch (_) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed.'), backgroundColor: AppColors.error)); }
    finally { if (mounted) setState(() => _isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.scaffold, appBar: AppBar(title: const Text('Post Circular')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Headline *', prefixIcon: Icon(Icons.campaign_rounded))),
        const SizedBox(height: 16), TextField(controller: _bodyCtrl, maxLines: 5, decoration: const InputDecoration(labelText: 'Message *', alignLabelWithHint: true)),
        const SizedBox(height: 24),
        SwitchListTile(title: const Text('Mark as IMPORTANT'), value: _isImportant, onChanged: (v) => setState(() => _isImportant = v), activeColor: AppColors.error, contentPadding: EdgeInsets.zero),
        const SizedBox(height: 48),
        ElevatedButton(onPressed: _isLoading ? null : _submit,
          child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Publish Announcement')),
      ])));
  }
}
