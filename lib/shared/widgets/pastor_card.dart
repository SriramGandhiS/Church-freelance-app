import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class PastorCard extends StatelessWidget {
  final String id;
  final String name;
  final String role;
  final String region;
  final String photoUrl;
  final bool circularMode;

  const PastorCard({super.key, required this.id, required this.name, required this.role, required this.region, required this.photoUrl, this.circularMode = false});

  @override
  Widget build(BuildContext context) {
    if (circularMode) {
      return GestureDetector(
        onTap: () => context.push('/members/$id'),
        child: SizedBox(
          width: 70,
          child: Column(
            children: [
              _avatar(24),
              const SizedBox(height: 6),
              Text(name.split(' ').last, style: GoogleFonts.sourceSans3(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary), maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => context.push('/members/$id'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
        child: Row(children: [
          _avatar(20),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: GoogleFonts.merriweather(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            Text('$role \u00b7 $region', style: GoogleFonts.sourceSans3(fontSize: 13, color: AppColors.textMuted)),
          ])),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ]),
      ),
    );
  }

  Widget _avatar(double radius) {
    final initials = name.split(' ').where((w) => w.isNotEmpty).map((w) => w[0]).take(2).join();
    if (photoUrl.isNotEmpty) {
      return CircleAvatar(radius: radius, backgroundColor: AppColors.primaryLight, backgroundImage: CachedNetworkImageProvider(photoUrl));
    }
    return CircleAvatar(radius: radius, backgroundColor: AppColors.primaryLight,
      child: Text(initials, style: GoogleFonts.merriweather(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: radius * 0.7)));
  }
}
