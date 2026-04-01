import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AdminGalleryUploadScreen extends StatelessWidget {
  const AdminGalleryUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.scaffold, appBar: AppBar(title: const Text('Upload to Gallery')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const TextField(decoration: InputDecoration(labelText: 'Album Title *', prefixIcon: Icon(Icons.title_rounded))),
        const SizedBox(height: 24),
        Container(height: 200, decoration: BoxDecoration(color: AppColors.primaryLighter, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primary, width: 2)),
          child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.add_photo_alternate_rounded, size: 64, color: AppColors.primary),
            SizedBox(height: 16), Text('Select photos to upload', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ])),
        const SizedBox(height: 48),
        ElevatedButton(onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gallery upload requires Firebase Storage setup.')));
        }, child: const Text('Upload Images')),
      ])));
  }
}
