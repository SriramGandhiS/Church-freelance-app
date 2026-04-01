import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/shimmer_loader.dart';

class AdminApprovalsScreen extends StatelessWidget {
  const AdminApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.scaffold, appBar: AppBar(title: const Text('Pending Approvals')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pastorApplications').where('status', isEqualTo: 'pending').snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const ShimmerList(itemCount: 4);
          if (!snap.hasData || snap.data!.docs.isEmpty) return const Center(child: Text('All caught up! No pending applications.'));
          return ListView.builder(padding: const EdgeInsets.all(16), itemCount: snap.data!.docs.length, itemBuilder: (_, i) {
            final d = snap.data!.docs[i]; final data = d.data() as Map<String, dynamic>;
            return Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(backgroundColor: AppColors.warningLight, child: Icon(Icons.person, color: AppColors.warning)),
              title: Text(data['name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${data['churchName'] ?? ''} \u00b7 ${data['region'] ?? ''}'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/admin/approvals/${d.id}')));
          });
        }));
  }
}
