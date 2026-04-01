import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonTap;

  const EmptyState({super.key, required this.icon, required this.title, required this.subtitle, this.buttonLabel, this.onButtonTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(padding: const EdgeInsets.all(24), decoration: const BoxDecoration(color: AppColors.primaryLighter, shape: BoxShape.circle),
          child: Icon(icon, size: 48, color: AppColors.primary)),
        const SizedBox(height: 24),
        Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
        if (buttonLabel != null && onButtonTap != null) ...[
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onButtonTap, child: Text(buttonLabel!)),
        ],
      ])),
    );
  }
}
