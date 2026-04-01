import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class DonationSuccessScreen extends StatelessWidget {
  const DonationSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.scaffold, body: Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(padding: const EdgeInsets.all(24), decoration: const BoxDecoration(color: AppColors.sageLight, shape: BoxShape.circle),
        child: const Icon(Icons.check_circle_rounded, size: 80, color: AppColors.sage)),
      const SizedBox(height: 32),
      Text('Thank You!', style: Theme.of(context).textTheme.displayLarge, textAlign: TextAlign.center),
      const SizedBox(height: 12),
      Text('Your donation has been received.\nMay God bless you abundantly.', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
      const SizedBox(height: 48),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => context.go('/home'), child: const Text('Return to Home'))),
    ]))));
  }
}
