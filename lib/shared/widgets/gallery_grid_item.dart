import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class GalleryGridItem extends StatelessWidget {
  final String imageUrl;
  const GalleryGridItem({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/gallery/photo?url=${Uri.encodeComponent(imageUrl)}'),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.divider)),
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover,
          placeholder: (_, __) => Container(color: AppColors.primaryLighter),
          errorWidget: (_, __, ___) => Container(color: AppColors.primaryLighter, child: const Icon(Icons.image_not_supported_rounded, color: AppColors.textMuted))),
      ),
    );
  }
}

class AlbumCard extends StatelessWidget {
  final String title;
  final String coverUrl;
  final int count;
  final VoidCallback onTap;

  const AlbumCard({super.key, required this.title, required this.coverUrl, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: coverUrl.isNotEmpty
              ? CachedNetworkImage(imageUrl: coverUrl, fit: BoxFit.cover, placeholder: (_, __) => Container(color: AppColors.primaryLighter), errorWidget: (_, __, ___) => _placeholder())
              : _placeholder(),
          ),
          Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text('$count photos', style: Theme.of(context).textTheme.bodySmall),
          ])),
        ]),
      ),
    );
  }

  Widget _placeholder() => Container(color: AppColors.primaryLighter, child: const Center(child: Icon(Icons.photo_library_rounded, size: 32, color: AppColors.primary)));
}
