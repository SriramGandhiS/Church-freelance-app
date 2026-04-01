import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class AciAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  const AciAppBar({super.key, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.amber.withOpacity(0.9), width: 1.5),
            ),
            child: ClipOval(child: Image.asset('assets/images/aci_logo.png', height: 36, width: 36,
              errorBuilder: (_, __, ___) => const Icon(Icons.church_rounded, color: AppColors.primary, size: 36))),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ACI Diocese', style: GoogleFonts.merriweather(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text('Apostolic Council of India', style: GoogleFonts.sourceSans3(fontSize: 10, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
