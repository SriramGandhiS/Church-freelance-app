import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  static const _albums = [
    {'id': 'events', 'title': 'Church Events', 'count': '12 photos', 'color': 0xFF4A7FBD, 'icon': 0xe3b2},
    {'id': 'bishop', 'title': 'Bishop & Leadership', 'count': '8 photos', 'color': 0xFF7B6FA6, 'icon': 0xe7fd},
    {'id': 'ordination', 'title': 'Ordination Services', 'count': '15 photos', 'color': 0xFFC47A7A, 'icon': 0xe547},
    {'id': 'fellowship', 'title': 'Pastors Fellowship', 'count': '20 photos', 'color': 0xFF5A8A6A, 'icon': 0xe7ef},
    {'id': 'bigmass', 'title': 'Big Mass 2025', 'count': '30 photos', 'color': 0xFF9B7D3A, 'icon': 0xe0c8},
    {'id': 'church', 'title': 'Church Life', 'count': '10 photos', 'color': 0xFF4A7FBD, 'icon': 0xe19d},
  ];

  // Real-ish placeholder colors for each album grid cell
  static const _gradients = [
    [Color(0xFF4A7FBD), Color(0xFF7B6FA6)],
    [Color(0xFF7B6FA6), Color(0xFFC47A7A)],
    [Color(0xFFC47A7A), Color(0xFF9B7D3A)],
    [Color(0xFF5A8A6A), Color(0xFF4A7FBD)],
    [Color(0xFF9B7D3A), Color(0xFF5A8A6A)],
    [Color(0xFF4A7FBD), Color(0xFFC47A7A)],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('Gallery'),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.canPop() ? context.pop() : context.go('/home')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: _albums.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85),
          itemBuilder: (_, i) {
            final a = _albums[i];
            return GestureDetector(
              onTap: () => context.push('/gallery/${a['id']}'),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: _gradients[i % _gradients.length], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(children: [
                  Center(child: Icon(Icons.photo_library_rounded, size: 48, color: Colors.white.withValues(alpha: 0.3))),
                  Positioned(bottom: 0, left: 0, right: 0, child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black54]),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(a['title'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), maxLines: 2),
                      Text(a['count'] as String, style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ]),
                  )),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }
}
