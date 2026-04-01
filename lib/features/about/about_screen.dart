import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/watermark_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatermarkScaffold(
      appBar: AppBar(
        title: const Text('About ACI Diocese'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // ── HERO HEADER ─────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              decoration: const BoxDecoration(
                color: AppColors.primaryLighter,
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/aci_logo.png',
                    height: 80, width: 80),
                  const SizedBox(height: 14),
                  Text('Apostolic Council of India Diocese',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.merriweather(
                      fontSize: 20, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  Text('Shepherding the Shepherds',
                    style: GoogleFonts.sourceSans3(
                      fontSize: 14, color: AppColors.textMuted,
                      fontStyle: FontStyle.italic)),
                  const SizedBox(height: 16),
                  // Registration badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border)),
                    child: Text('Reg. No 62/B.k.4/2013 · Est. 16 October 2013',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 11, color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 20),

            // ── ABOUT THE DIOCESE ──────────────────────────────────
            _SectionCard(
              icon: Icons.account_balance_rounded,
              iconBg: AppColors.primaryLighter,
              title: 'About the Diocese',
              child: Text(AppStrings.aboutDiocese,
                style: GoogleFonts.sourceSans3(
                  fontSize: 14, height: 1.7,
                  color: AppColors.textSecondary)),
            ),

            // ── MISSION ─────────────────────────────────────────────
            _SectionCard(
              icon: Icons.flag_rounded,
              iconBg: AppColors.lavenderLighter,
              title: 'Our Mission',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MissionPoint(
                    'Bringing independent ministers of God under a centralised setup by recognising their calling, upgrading them through ordination training according to the Word of God and the law of the land.'),
                  _MissionPoint(
                    'Supporting pastors who labour alone — providing spiritual covering, fellowship, and administrative recognition under an episcopal structure.'),
                  _MissionPoint(
                    'Spreading the Gospel of Jesus Christ across Tamilnadu, India and the world through the ordained ministers of ACI Diocese.'),
                  _MissionPoint(
                    'Enabling ordained ministers to perform Christian Episcopal rites recognised under Part I, Section 5(1) and Part IV Sections 32–34 of the Indian Christian Marriage Act 1872.'),
                ],
              ),
            ),

            // ── VISION VERSE ────────────────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.blushLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.blush.withOpacity(0.3)),
              ),
              child: Column(children: [
                const Icon(Icons.format_quote_rounded,
                  color: AppColors.blush, size: 32),
                const SizedBox(height: 10),
                Text(
                  '"And I will set up one shepherd over them, and he shall feed them, even my servant David; he shall feed them, and he shall be their shepherd."',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.merriweather(
                    fontSize: 14, height: 1.7,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Text('— Ezekiel 34:23',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: AppColors.textMuted)),
              ]),
            ),

            const SizedBox(height: 20),

            // ── FOUNDER SECTION ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Founder & Bishop',
                style: GoogleFonts.merriweather(
                  fontSize: 18, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
            ),
            const SizedBox(height: 12),

            // Founder photo card — fluid flowing image
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                color: AppColors.surface,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Photo
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16)),
                    child: Image.asset(
                      'assets/images/founder.jpg',
                      height: 260,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 260,
                        alignment: Alignment.center,
                        color: AppColors.primaryLighter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/aci_logo.png', width: 90, height: 90),
                            const SizedBox(height: 12),
                            const Text('Image not available',
                              style: TextStyle(color: AppColors.primary, fontSize: 12))
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.05, end: 0),
                  // Name + title below photo
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rt. Rev. Johnson Durai S.',
                          style: GoogleFonts.merriweather(
                            fontSize: 18, fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLighter,
                              borderRadius: BorderRadius.circular(20)),
                            child: Text('Bishop & Founder',
                              style: GoogleFonts.sourceSans3(
                                fontSize: 11, fontWeight: FontWeight.w700,
                                color: AppColors.primary)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.lavenderLighter,
                              borderRadius: BorderRadius.circular(20)),
                            child: Text('25+ Years Ministry',
                              style: GoogleFonts.sourceSans3(
                                fontSize: 11, fontWeight: FontWeight.w600,
                                color: AppColors.lavender)),
                          ),
                        ]),
                        const SizedBox(height: 4),
                        Text('Power in the Word Ministries',
                          style: GoogleFonts.sourceSans3(
                            fontSize: 13, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Founder biography
            _SectionCard(
              icon: Icons.person_outline_rounded,
              iconBg: AppColors.blushLight,
              title: 'About the Founder',
              child: Text(AppStrings.bishopBio,
                style: GoogleFonts.sourceSans3(
                  fontSize: 14, height: 1.75,
                  color: AppColors.textSecondary)),
            ),

            // ── LEGAL / REGISTRATION ────────────────────────────────
            _SectionCard(
              icon: Icons.verified_rounded,
              iconBg: AppColors.sageLight,
              title: 'Legal Registration',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegalRow('Trust Act', 'Indian Trust Act 1882'),
                  _LegalRow('Registration No', 'Reg. No 62/B.k.4/2013'),
                  _LegalRow('Founded', '16th October 2013'),
                  _LegalRow('Office', '6/110, Melapatty, Hanumantharayan Kottai – 624002, Dindigul, Tamilnadu'),
                  _LegalRow('Indian Christian Marriage Act', 'Part I Sec 5(1), Part IV Sec 32–34, 37, Part VI Sec 64'),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Contact shortcut
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () => context.push('/contact'),
                icon: const Icon(Icons.phone_rounded),
                label: const Text('Contact the Diocese Office'),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ──────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final Widget child;
  const _SectionCard({required this.icon, required this.iconBg,
    required this.title, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: AppColors.primary)),
        const SizedBox(width: 10),
        Text(title, style: GoogleFonts.merriweather(
          fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ]),
      const SizedBox(height: 12),
      const Divider(height: 1),
      const SizedBox(height: 12),
      child,
    ]),
  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.03, end: 0);
}

class _MissionPoint extends StatelessWidget {
  final String text;
  const _MissionPoint(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: const EdgeInsets.only(top: 5),
        width: 7, height: 7,
        decoration: const BoxDecoration(
          color: AppColors.primary, shape: BoxShape.circle)),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.sourceSans3(
        fontSize: 14, height: 1.65, color: AppColors.textSecondary))),
    ]),
  );
}

class _LegalRow extends StatelessWidget {
  final String label, value;
  const _LegalRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: 130,
        child: Text(label, style: GoogleFonts.sourceSans3(
          fontSize: 12, fontWeight: FontWeight.w600,
          color: AppColors.textMuted))),
      Expanded(child: Text(value, style: GoogleFonts.sourceSans3(
        fontSize: 13, fontWeight: FontWeight.w600,
        color: AppColors.textPrimary))),
    ]),
  );
}
