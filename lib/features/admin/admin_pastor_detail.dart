import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/shimmer_loader.dart';

class AdminPastorDetailScreen extends StatefulWidget {
  final String pastorId;
  const AdminPastorDetailScreen({super.key, required this.pastorId});
  @override
  State<AdminPastorDetailScreen> createState() => _AdminPastorDetailScreenState();
}

class _AdminPastorDetailScreenState extends State<AdminPastorDetailScreen> {
  bool _isLoading = false;

  Future<void> _updateStatus(String status) async {
    setState(() => _isLoading = true);
    try {
      final docRef = FirebaseFirestore.instance.collection('pastorApplications').doc(widget.pastorId);
      if (status == 'approved') {
        final doc = await docRef.get();
        final data = doc.data() as Map<String, dynamic>;
        await FirebaseFirestore.instance.collection('pastors').add({
          'name': data['name'], 'role': 'District Pastor', 'region': data['region'],
          'phone': data['phone'], 'email': data['email'], 'photoUrl': '', 'status': 'approved',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      await docRef.update({'status': status});
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Application $status'))); context.pop(); }
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action failed.')));
    } finally { if (mounted) setState(() => _isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.scaffold, appBar: AppBar(title: const Text('Review Application')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('pastorApplications').doc(widget.pastorId).get(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const ShimmerList(itemCount: 1);
          if (!snap.hasData || !snap.data!.exists) return const Center(child: Text('Application not found.'));
          final data = snap.data!.data() as Map<String, dynamic>;
          return SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Applicant Details', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            _info('Name', data['name'] ?? ''), _info('Phone', data['phone'] ?? ''), _info('Email', data['email'] ?? ''),
            const SizedBox(height: 24),
            Text('Ministry Info', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            _info('Church Name', data['churchName'] ?? ''), _info('Address', data['address'] ?? ''), _info('Region', data['region'] ?? ''),
            const SizedBox(height: 48),
            if (_isLoading) const Center(child: CircularProgressIndicator())
            else ...[
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => _updateStatus('approved'), child: const Text('Approve & Add to Registry'))),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.blushLight, foregroundColor: AppColors.error),
                onPressed: () => _updateStatus('rejected'), child: const Text('Reject Application'))),
            ],
            const SizedBox(height: 40),
          ]));
        }));
  }

  Widget _info(String label, String val) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.bold)),
    const SizedBox(height: 4), Text(val, style: const TextStyle(fontSize: 16)), const Divider()]));
}
