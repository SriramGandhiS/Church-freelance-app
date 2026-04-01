import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';

class ShimmerLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  const ShimmerLoader({super.key, required this.width, required this.height, this.borderRadius = 8});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.divider,
      highlightColor: AppColors.primaryLighter,
      child: Container(width: width, height: height, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(borderRadius))),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ShimmerLoader(width: double.infinity, height: 24),
        SizedBox(height: 12),
        ShimmerLoader(width: 150, height: 16),
        SizedBox(height: 16),
        ShimmerLoader(width: double.infinity, height: 48),
      ]),
    );
  }
}

class ShimmerList extends StatelessWidget {
  final int itemCount;
  const ShimmerList({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: itemCount, itemBuilder: (_, __) => const ShimmerCard());
  }
}
