import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/watermark_scaffold.dart';
import '../../shared/widgets/aci_app_bar.dart';
import '../../shared/widgets/app_drawer.dart';
import '../../shared/widgets/section_header.dart';

// ── Diocese/District data ───────────────────────────────────
class _Diocese {
  final String name;
  final String icon;
  final List<String> districts;
  const _Diocese(this.name, this.icon, this.districts);
}

const _dioceses = [
  _Diocese('ACI Dindigul Headquarters', '🏛', ['Dindigul', 'Theni']),
  _Diocese('ACI Tirupattur',    '⛪', ['Tirupattur', 'Vellore', 'Ranipet', 'Krishnagiri']),
  _Diocese('ACI Madurai',       '🕍', ['Madurai', 'Ramnad', 'Sivagangai']),
  _Diocese('ACI Trichy',        '✝', ['Trichy', 'Pudukottai', 'Tanjavur', 'Karur']),
  _Diocese('ACI Villupuram',    '⛪', ['Villupuram', 'Pondicherry']),
  _Diocese('ACI Chennai',       '🏙', ['Chennai', 'Kanchipuram', 'Thiruvallur']),
  _Diocese('ACI Virudhunagar',  '⛪', ['Virudhunagar']),
  _Diocese('ACI Kanniyakumari', '🌊', ['Kanniyakumari', 'Tirunelveli', 'Tuticorin']),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// null = no filter (show all); set when user picks a diocese
  _Diocese? _selectedDiocese;

  void _openDioceseSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DioceseSheet(
        selected: _selectedDiocese,
        onSelect: (d) {
          setState(() => _selectedDiocese = d);
          Navigator.pop(context);
        },
        onClear: () {
          setState(() => _selectedDiocese = null);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WatermarkScaffold(
      appBar: const AciAppBar(actions: [SizedBox(width: 12)]),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _BannerCarousel(),
          const SizedBox(height: 16),

          // ── Search Bar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              onTap: () => context.push('/churches'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryLight),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: Row(children: [
                  const Icon(Icons.search_rounded, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text('Search Church Directory...', style: TextStyle(color: AppColors.textHint, fontSize: 15)),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AciDioceseButton(
                  selected: _selectedDiocese,
                  onTap: _openDioceseSheet,
                ),
                const SizedBox(height: 12),
                _AboutButton(onTap: () => context.push('/about')),
                const SizedBox(height: 12),
                _SynodButton(onTap: () => context.push('/synod')),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Church Circulars ──
          SectionHeader('Church Circulars'),
          const SizedBox(height: 12),
          const _CircularsRings(),
          const SizedBox(height: 12),

          // ── Location & Contact ──
          _LocationCard(),
          const SizedBox(height: 12),

          // ── Upcoming Events (At bottom) ──
          SectionHeader('Upcoming Events', onViewAll: () => context.push('/events')),
          const SizedBox(height: 4),
          _EventsSection(),
          
          const SizedBox(height: 100),
        ]),
      ),
    );
  }
}

// ── ACI Diocese Button (Subtle Ring) ───────────────────────────────────
class _AciDioceseButton extends StatefulWidget {
  final _Diocese? selected;
  final VoidCallback onTap;
  const _AciDioceseButton({required this.selected, required this.onTap});

  @override
  State<_AciDioceseButton> createState() => _AciDioceseButtonState();
}

class _AciDioceseButtonState extends State<_AciDioceseButton> with SingleTickerProviderStateMixin {
  late final AnimationController _ringCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();

  @override
  void dispose() {
    _ringCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool active = widget.selected != null;
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // The Subtle Spinning Background
            Positioned.fill(
              child: Transform.scale(
                scale: 3.5, // ensures it covers corners during rotation without affecting layout size
                child: RotationTransition(
                  turns: _ringCtrl,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: SweepGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.4), 
                          AppColors.lavender.withOpacity(0.1), 
                          AppColors.primary.withOpacity(0.05), 
                          AppColors.primary.withOpacity(0.4)
                        ],
                        stops: const [0.0, 0.4, 0.8, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Inner content acting as the mask
            Container(
              margin: const EdgeInsets.all(2.5), // Subtle border thickness
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              ),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: active ? Colors.white24 : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.church_rounded, size: 28, color: active ? Colors.white : AppColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    active ? widget.selected!.name : 'ACI Diocese',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: active ? Colors.white : AppColors.textPrimary,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    active ? widget.selected!.districts.join(', ') : 'Select your diocese',
                    style: TextStyle(
                      fontSize: 12,
                      color: active ? Colors.white70 : AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ])),
                Icon(Icons.keyboard_arrow_down_rounded, color: active ? Colors.white : AppColors.primary, size: 28),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// ── About Button ───────────────────────────────────
class _AboutButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AboutButton({required this.onTap});

  @override
  State<_AboutButton> createState() => _AboutButtonState();
}

class _AboutButtonState extends State<_AboutButton> with SingleTickerProviderStateMixin {
  late final AnimationController _ringCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();

  @override
  void dispose() {
    _ringCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Transform.scale(
                scale: 3.5,
                child: RotationTransition(
                  turns: _ringCtrl,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: SweepGradient(
                        colors: [
                          AppColors.blush.withOpacity(0.3), 
                          AppColors.primary.withOpacity(0.05), 
                          Colors.purpleAccent.withOpacity(0.05), 
                          AppColors.blush.withOpacity(0.3)
                        ],
                        stops: const [0.0, 0.4, 0.8, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(2.5),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.blushLight, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.info_outline_rounded, size: 26, color: AppColors.blush),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text('About ACI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textHint),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Synod Button ───────────────────────────────────
class _SynodButton extends StatefulWidget {
  final VoidCallback onTap;
  const _SynodButton({required this.onTap});

  @override
  State<_SynodButton> createState() => _SynodButtonState();
}

class _SynodButtonState extends State<_SynodButton> with SingleTickerProviderStateMixin {
  late final AnimationController _ringCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();

  @override
  void dispose() {
    _ringCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Transform.scale(
                scale: 3.5,
                child: RotationTransition(
                  turns: _ringCtrl,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: SweepGradient(
                        colors: [
                          Colors.amber.withOpacity(0.3), 
                          Colors.orange.withOpacity(0.1), 
                          AppColors.primary.withOpacity(0.05), 
                          Colors.amber.withOpacity(0.3)
                        ],
                        stops: const [0.0, 0.4, 0.8, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(2.5),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.amber.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.account_balance_rounded, size: 26, color: Colors.amber),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text('Synod Council', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textHint),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Diocese Selection Sheet ───────────────────────────────────
class _DioceseSheet extends StatefulWidget {
  final _Diocese? selected;
  final ValueChanged<_Diocese> onSelect;
  final VoidCallback onClear;
  const _DioceseSheet({required this.selected, required this.onSelect, required this.onClear});
  @override
  State<_DioceseSheet> createState() => _DioceseSheetState();
}

class _DioceseSheetState extends State<_DioceseSheet> {
  _Diocese? _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Handle bar
        Container(margin: const EdgeInsets.only(top: 12, bottom: 8), width: 40, height: 4,
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),

        // Header
        Padding(padding: const EdgeInsets.fromLTRB(20, 4, 16, 12), child: Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.church_rounded, color: AppColors.primary, size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('ACI Diocese', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            const Text('Select a diocese to filter pastors', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ])),
          if (widget.selected != null)
            TextButton(onPressed: widget.onClear, child: const Text('Clear', style: TextStyle(color: AppColors.primary))),
        ])),

        const Divider(height: 1),

        // Diocese list
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.55),
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: _dioceses.length,
            itemBuilder: (_, i) {
              final d = _dioceses[i];
              final isExpanded = _expanded?.name == d.name;
              final isSelected = widget.selected?.name == d.name;
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                InkWell(
                  onTap: () => setState(() => _expanded = isExpanded ? null : d),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    color: isSelected ? AppColors.primaryLight.withOpacity(0.3) : null,
                    child: Row(children: [
                      Text(d.icon, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(d.name, style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w800,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        )),
                        Text(d.districts.join(' · '), style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ])),
                      if (isSelected)
                        const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
                      Icon(isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                          color: AppColors.textMuted, size: 20),
                    ]),
                  ),
                ),
                // Sub-districts
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 220),
                  crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.fromLTRB(52, 0, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...d.districts.map((dist) => InkWell(
                          onTap: () {
                            Navigator.pop(context); // Close sheet
                            context.push('/region', extra: {'diocese': d.name, 'district': dist, 'districts': d.districts});
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLighter,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(children: [
                              const Icon(Icons.location_city_rounded, size: 14, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(dist, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                            ]),
                          ),
                        )),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.church_rounded, size: 16),
                            label: Text('View all in ${d.name}'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.pop(context); // Close sheet
                              context.push('/region', extra: {'diocese': d.name, 'district': 'All', 'districts': d.districts});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
              ]);
            },
          ),
        ),
      ]),
    );
  }
}

// ── BANNER ───────────────────────────────────
class _BannerCarousel extends StatefulWidget {
  const _BannerCarousel();
  @override State<_BannerCarousel> createState() => _BannerCarouselState();
}
class _BannerCarouselState extends State<_BannerCarousel> {
  final _ctrl = PageController();
  int _i = 0;

  static const _slides = [
    {'img': 'assets/images/banner_pastors.png',  'title': 'ACI Diocese Leadership', 'sub': 'Apostolic Council of India Diocese · Dindigul'},
    {'img': 'assets/images/banner_church.png',   'title': 'Central Diocesan Office', 'sub': 'Hanumantharayan Kottai, Dindigul · Est. 2013'},
    {'img': 'assets/images/gallery_collage.png', 'title': 'Ministry Across Tamilnadu', 'sub': 'Ordinations · Conferences · Zonal Meets'},
  ];

  @override void initState() { super.initState(); Future.delayed(const Duration(seconds: 4), _auto); }
  void _auto() {
    if (!mounted) return;
    final next = (_i + 1) % _slides.length;
    _ctrl.animateToPage(next, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    Future.delayed(const Duration(seconds: 4), _auto);
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 210, child: Stack(children: [
      PageView.builder(
        controller: _ctrl,
        itemCount: _slides.length,
        onPageChanged: (i) => setState(() => _i = i),
        itemBuilder: (_, i) {
          final s = _slides[i];
          return Stack(fit: StackFit.expand, children: [
            Image.asset(s['img']!, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary, AppColors.lavender], begin: Alignment.topLeft, end: Alignment.bottomRight)))),
            Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black12, Colors.black54]))),
            Positioned(bottom: 0, left: 0, right: 0, child: Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(s['title']!, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 8, color: Colors.black54)])),
              const SizedBox(height: 2),
              Text(s['sub']!, style: const TextStyle(color: Colors.white70, fontSize: 12, shadows: [Shadow(blurRadius: 6, color: Colors.black54)])),
            ]))),
          ]);
        }),
      Positioned(bottom: 8, right: 14, child: Row(
        children: List.generate(_slides.length, (i) => Container(
          width: _i == i ? 18 : 6, height: 6, margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(color: _i == i ? Colors.white : Colors.white54, borderRadius: BorderRadius.circular(3)))))),
    ]));
  }
}

// ── EVENTS ───────────────────────────────────
class _EventsSection extends StatelessWidget {
  static const _events = [
    {'title': 'Holy Communion Service — Big Mass 2026', 'date': 'April 15, 2026 · 10:00 AM', 'location': 'Central Office, Dindigul', 'tag': 'BIG MASS'},
    {'title': 'Annual Synod Meeting 2026', 'date': 'May 20, 2026 · 9:00 AM', 'location': 'Diocesan Office, Dindigul', 'tag': 'SYNOD'},
    {'title': 'Ordination Service 2026', 'date': 'June 10, 2026 · 10:30 AM', 'location': 'Diocesan Office, Dindigul', 'tag': 'ORDINATION'},
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 155, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _events.length, itemBuilder: (_, i) {
        final e = _events[i];
        return GestureDetector(
          onTap: () => context.push('/events'),
          child: Container(width: 280, margin: const EdgeInsets.only(right: 12), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                child: Text(e['tag']!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
              const SizedBox(height: 10),
              Text(e['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
              const Spacer(),
              Row(children: [const Icon(Icons.calendar_today_rounded, size: 13, color: AppColors.textMuted), const SizedBox(width: 6), Expanded(child: Text(e['date']!, style: TextStyle(fontSize: 12, color: AppColors.textMuted)))]),
              const SizedBox(height: 4),
              Row(children: [const Icon(Icons.location_on_rounded, size: 13, color: AppColors.textMuted), const SizedBox(width: 6), Expanded(child: Text(e['location']!, style: TextStyle(fontSize: 11, color: AppColors.textMuted), overflow: TextOverflow.ellipsis))]),
            ])
          ),
        );
      }));
  }
}

// ── CIRCULARS (MOVING RINGS) ───────────────────────────────────
class _CircularsRings extends StatefulWidget {
  const _CircularsRings();
  @override State<_CircularsRings> createState() => _CircularsRingsState();
}
class _CircularsRingsState extends State<_CircularsRings> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  static const _circulars = [
    {'title': 'Synod 2026', 'icon': Icons.campaign_rounded, 'color': AppColors.primary},
    {'title': 'New Overseer', 'icon': Icons.person_add_rounded, 'color': AppColors.lavender},
    {'title': 'Mass Venue', 'icon': Icons.location_on_rounded, 'color': AppColors.blush},
    {'title': 'Prayer Meet', 'icon': Icons.volunteer_activism_rounded, 'color': AppColors.sage},
  ];
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) {
    return SizedBox(height: 100, child: ListView.builder(
      scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _circulars.length, itemBuilder: (ctx, i) {
        final c = _circulars[i];
        return Padding(padding: const EdgeInsets.only(right: 20), child: GestureDetector(
          onTap: () => context.push('/events'),
          child: Column(children: [
            Stack(alignment: Alignment.center, children: [
              RotationTransition(
                turns: _ctrl,
                child: Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(colors: [c['color'] as Color, (c['color'] as Color).withOpacity(0.1), c['color'] as Color]),
                  ),
                  child: Padding(padding: const EdgeInsets.all(3), child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.surface),
                  )),
                ),
              ),
              Icon(c['icon'] as IconData, color: c['color'] as Color, size: 28),
            ]),
            const SizedBox(height: 8),
            Text(c['title'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ]),
        ));
      }
    ));
  }
}

// Removing Pastors, NoResults and Gallery sections

// ── LOCATION ───────────────────────────────────
class _LocationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.lavenderLighter, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Icon(Icons.location_on_rounded, color: AppColors.lavender), const SizedBox(width: 8), Text('Central Diocesan Office', style: Theme.of(context).textTheme.titleMedium)]),
        const SizedBox(height: 8),
        Text(AppStrings.address, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        GestureDetector(onTap: () => launchUrl(Uri.parse('tel:${AppStrings.phone}')), child: Text('📞 ${AppStrings.phone}', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14))),
        const SizedBox(height: 8),
        Text('Office Hours: ${AppStrings.officeHours}', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(icon: const Icon(Icons.directions_rounded), label: const Text('Get Directions'),
          onPressed: () => launchUrl(Uri.parse(AppStrings.mapsUrl), mode: LaunchMode.externalApplication))),
      ])));
  }
}
