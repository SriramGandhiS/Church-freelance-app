import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

/// TEST MODE: No payment, no document upload required — submit directly
class JoinIntroScreen extends StatelessWidget {
  const JoinIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: const Text('Join ACI Diocese'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.canPop() ? context.pop() : context.go('/home'))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.sage, Color(0xFF3d6b4a)]), borderRadius: BorderRadius.circular(16)),
          child: Column(children: [
            const Icon(Icons.church_rounded, size: 60, color: Colors.white),
            const SizedBox(height: 12),
            const Text('Register as a Pastor', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 6),
            const Text('Join the Apostolic Council of India Diocese as an ordained minister', style: TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center),
          ])),
        const SizedBox(height: 24),
        const Text('Requirements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        ...[
          'You must be an ordained minister of Christ',
          'Active in ministry for at least 2 years',
          'Willing to abide by ACI Diocese constitution',
          'Your church must be legally established',
          'Agree to episcopal oversight',
        ].map((r) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.sage, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(r, style: const TextStyle(fontSize: 14))),
        ]))),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.sage, foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          onPressed: () => context.push('/join/form'),
          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Begin Registration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), SizedBox(width: 8), Icon(Icons.arrow_forward_rounded)]),
        )),
      ])),
    );
  }
}
