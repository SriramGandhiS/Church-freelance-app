import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class WatermarkScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? floatingActionButton;

  const WatermarkScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.drawer,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.12,
              child: Center(
                child: Image.asset(
                  'assets/images/aci_logo.png',
                  width: MediaQuery.of(context).size.width * 0.65,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          body,
        ],
      ),
    );
  }
}
