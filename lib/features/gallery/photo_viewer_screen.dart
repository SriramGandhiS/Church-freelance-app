import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';

class PhotoViewerScreen extends StatelessWidget {
  final String photoUrl;
  const PhotoViewerScreen({super.key, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        actions: [
          IconButton(icon: const Icon(Icons.share_rounded), onPressed: () => Share.share(photoUrl.isNotEmpty ? photoUrl : 'ACI Diocese Photo')),
        ],
      ),
      body: Center(child: photoUrl.isNotEmpty
          ? Image.network(photoUrl, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_rounded, color: Colors.white54, size: 80))
          : const Icon(Icons.photo_rounded, color: Colors.white38, size: 80)),
    );
  }
}
