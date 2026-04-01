import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pc = PageController();
  int _page = 0;

  final _slides = const [
    _Slide(Color(0xFFEFF5FC), Icons.church_rounded, 'Welcome to ACI Diocese', 'Apostolic Council of India Diocese \u2014 Shepherding the Shepherds'),
    _Slide(Color(0xFFF5F3FC), Icons.groups_rounded, 'Stay Connected', 'Events, meetings, church updates \u2014 all in one place'),
    _Slide(Color(0xFFF8EDED), Icons.volunteer_activism_rounded, 'Join the Community', 'Register as a pastor, donate, send prayer requests'),
  ];

  Future<void> _done() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(backgroundColor: Colors.transparent, actions: [
        if (_page < _slides.length - 1) TextButton(onPressed: _done, child: Text('Skip', style: TextStyle(color: AppColors.textMuted))),
      ]),
      body: Column(children: [
        Expanded(child: PageView.builder(
          controller: _pc, itemCount: _slides.length,
          onPageChanged: (i) => setState(() => _page = i),
          itemBuilder: (_, i) {
            final s = _slides[i];
            return Container(
              color: s.bg,
              padding: const EdgeInsets.all(40),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(s.icon, size: 100, color: AppColors.primary),
                const SizedBox(height: 48),
                Text(s.title, style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Text(s.subtitle, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
              ]),
            );
          },
        )),
        Padding(padding: const EdgeInsets.all(24), child: Column(children: [
          SmoothPageIndicator(controller: _pc, count: _slides.length, effect: ExpandingDotsEffect(
            activeDotColor: AppColors.primary, dotColor: AppColors.divider, dotHeight: 8, dotWidth: 8, expansionFactor: 3)),
          const SizedBox(height: 32),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () { if (_page == _slides.length - 1) _done(); else _pc.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut); },
            child: Text(_page == _slides.length - 1 ? 'Get Started' : 'Next'),
          )),
          const SizedBox(height: 16),
        ])),
      ]),
    );
  }
}

class _Slide {
  final Color bg;
  final IconData icon;
  final String title;
  final String subtitle;
  const _Slide(this.bg, this.icon, this.title, this.subtitle);
}
