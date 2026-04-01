import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PastorProfileScreen extends StatelessWidget {
  const PastorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.scaffold, appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
        const CircleAvatar(radius: 50, backgroundColor: AppColors.primaryLight, child: Icon(Icons.person_rounded, size: 50, color: AppColors.primary)),
        const SizedBox(height: 32),
        const TextField(decoration: InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline_rounded))),
        const SizedBox(height: 16),
        const TextField(decoration: InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone_outlined))),
        const SizedBox(height: 16),
        const TextField(decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined))),
        const SizedBox(height: 16),
        const TextField(decoration: InputDecoration(labelText: 'Church Name', prefixIcon: Icon(Icons.church_rounded))),
        const SizedBox(height: 48),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully.'), backgroundColor: AppColors.success));
        }, child: const Text('Save Changes'))),
      ])));
  }
}
