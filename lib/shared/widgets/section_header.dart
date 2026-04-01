import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const SectionHeader(this.title, {super.key, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Text('View All \u2192', style: TextStyle(color: AppColors.primary, fontSize: 13, decoration: TextDecoration.underline)),
            ),
        ],
      ),
    );
  }
}
