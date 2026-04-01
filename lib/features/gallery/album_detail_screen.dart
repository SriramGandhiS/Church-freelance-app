import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class AlbumDetailScreen extends StatelessWidget {
  final String albumId;
  const AlbumDetailScreen({super.key, required this.albumId});

  static const _albums = {
    'events': {'title': 'Church Events', 'count': 12},
    'bishop': {'title': 'Bishop & Leadership', 'count': 8},
    'ordination': {'title': 'Ordination Services', 'count': 15},
    'fellowship': {'title': 'Pastors Fellowship', 'count': 20},
    'bigmass': {'title': 'Big Mass 2025', 'count': 30},
    'church': {'title': 'Church Life', 'count': 10},
  };

  static const _gradients = [
    [Color(0xFF4A7FBD), Color(0xFF7B6FA6)],
    [Color(0xFF7B6FA6), Color(0xFFC47A7A)],
    [Color(0xFFC47A7A), Color(0xFF5A8A6A)],
    [Color(0xFF5A8A6A), Color(0xFF9B7D3A)],
    [Color(0xFF9B7D3A), Color(0xFF4A7FBD)],
    [Color(0xFF4A7FBD), Color(0xFFc47a7a)],
  ];

  @override
  Widget build(BuildContext context) {
    final info = _albums[albumId] ?? {'title': 'Album', 'count': 6};
    final count = info['count'] as int;
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(info['title'] as String),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: count,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 6, mainAxisSpacing: 6),
        itemBuilder: (_, i) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: _gradients[i % _gradients.length], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.church_rounded, color: Colors.white.withValues(alpha: 0.4), size: 24),
            const SizedBox(height: 4),
            Text('${i + 1}', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10)),
          ])),
        ),
      ),
    );
  }
}
