import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';

class PrayerRequestScreen extends StatefulWidget {
  const PrayerRequestScreen({super.key});
  @override
  State<PrayerRequestScreen> createState() => _PrayerRequestScreenState();
}

class _PrayerRequestScreenState extends State<PrayerRequestScreen> {
  final _name = TextEditingController();
  final _mobile = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_name.text.isEmpty || _message.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your name and prayer request.')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('prayerRequests').add({
        'name': _name.text.trim(), 'mobile': _mobile.text.trim(), 'email': _email.text.trim(),
        'message': _message.text.trim(), 'createdAt': FieldValue.serverTimestamp(), 'isRead': false,
      });
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your prayer request has been sent. God bless you.'), backgroundColor: AppColors.success)); Navigator.of(context).pop(); }
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to send. Please try again.'), backgroundColor: AppColors.error));
    } finally { if (mounted) setState(() => _isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.scaffold, appBar: AppBar(title: const Text('Prayer Request')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Share your prayer needs with us.', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text('Our pastoral team will pray for you.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted)),
        const SizedBox(height: 24),
        TextField(controller: _name, decoration: const InputDecoration(labelText: 'Your Name *', prefixIcon: Icon(Icons.person_rounded)), textCapitalization: TextCapitalization.words),
        const SizedBox(height: 16),
        TextField(controller: _mobile, decoration: const InputDecoration(labelText: 'Mobile (optional)', prefixIcon: Icon(Icons.phone_rounded)), keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email (optional)', prefixIcon: Icon(Icons.email_rounded)), keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        TextField(controller: _message, maxLines: 5, maxLength: 500, decoration: const InputDecoration(labelText: 'Prayer Request *', alignLabelWithHint: true)),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Submit Prayer Request'))),
        const SizedBox(height: 40),
      ])));
  }
}
