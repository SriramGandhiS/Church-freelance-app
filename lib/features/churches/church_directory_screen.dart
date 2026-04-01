import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';

class ChurchDirectoryScreen extends ConsumerStatefulWidget {
  const ChurchDirectoryScreen({super.key});
  @override
  ConsumerState<ChurchDirectoryScreen> createState() => _ChurchDirectoryScreenState();
}

class _ChurchDirectoryScreenState extends ConsumerState<ChurchDirectoryScreen>
    with SingleTickerProviderStateMixin {

  final _searchController = TextEditingController();
  String _searchQuery = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('Church Directory'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: GoogleFonts.sourceSans3(
            fontSize: 14, fontWeight: FontWeight.w700),
          tabs: const [
            Tab(text: 'Search by ID'),
            Tab(text: 'Browse by Zone'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SearchTab(),
          _ZoneBrowseTab(),
        ],
      ),
    );
  }
}

// ── TAB 1: Search by Church ID ───────────────────────────────────────────────
class _SearchTab extends StatefulWidget {
  @override
  State<_SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<_SearchTab> {
  final _controller = TextEditingController();
  String _query = '';
  bool _searched = false;
  late final Stream<QuerySnapshot> _churchesStream;
  List<Map<String, dynamic>> _localData = [];
  bool _isUsingLocalFallback = false;
  bool _isLoadingLocal = false;

  @override
  void initState() {
    super.initState();
    _churchesStream = FirebaseFirestore.instance.collection('churches').where('isActive', isEqualTo: true).snapshots();
  }

  Future<void> _loadLocalDataFallback() async {
    if (_isLoadingLocal || _localData.isNotEmpty) return;
    setState(() => _isLoadingLocal = true);
    
    try {
      final raw = await DefaultAssetBundle.of(context).loadString('asset      final headers = lines[0].map((h) => h.trim().replaceAll('"', '')).toList();
      final List<Map<String, dynamic>> parsed = [];

      for (int i = 1; i < lines.length; i++) {
        final cells = lines[i];
        if (cells.isEmpty) continue;
        
        final Map<String, dynamic> rowData = {};
        for (int j = 0; j < headers.length && j < cells.length; j++) {
           rowData[headers[j]] = cells[j].trim();
        }
        
        final churchId = rowData['Reg.No'] ?? '';
        if (churchId.isEmpty) continue;

        final mapped = {
          'sNo': rowData['S.No'] ?? '',
          'churchId': churchId,
          'pastorName': rowData['Name'] ?? 'No Name',
          'churchName': rowData['Church Name'] ?? '',
          'districtName': rowData['District'] ?? rowData['Distirct'] ?? '',
          'zoneName': rowData['Zone'] ?? '',
          'pastorPhone': rowData['Phone No.'] ?? '',
          'designation': rowData['Designation'] ?? '',
          'address': rowData['Contact Address'] ?? '',
          'status': rowData['Status'] ?? 'Active',
          'isActive': true,
        };
        
        parsed.add(mapped);
      }
      
      setState(() {
        _localData = parsed;
        _isUsingLocalFallback = true;
        _isLoadingLocal = false;
      });
      debugPrint('--- [OFFLINE] Total Records Loaded: ${parsed.length} ---');
    } catch (e) {
      debugPrint('--- [OFFLINE ERROR] CSV Parsing failed: $e ---');
      if (mounted) setState(() => _isLoadingLocal = false);
    }
  }

  List<List<String>> _parseCsvRobust(String raw) {
    final result = <List<String>>[];
    bool inQuotes = false;
    var row = <String>[];
    var buf = StringBuffer();

    for (int i = 0; i < raw.length; i++) {
      final char = raw[i];
      if (char == '"') {
        if (i + 1 < raw.length && raw[i + 1] == '"') {
           buf.write('"'); i++;
        } else { inQuotes = !inQuotes; }
      } else if (char == ',' && !inQuotes) {
        row.add(buf.toString().trim());
        buf.clear();
      } else if ((char == '\n' || char == '\r') && !inQuotes) {
        if (char == '\r' && i+1 < raw.length && raw[i+1] == '\n') i++;
        row.add(buf.toString().trim());
        if (row.isNotEmpty) result.add(List.from(row));
        row.clear(); buf.clear();
      } else { buf.write(char); }
    }
    if (buf.isNotEmpty || row.isNotEmpty) {
      row.add(buf.toString().trim());
      result.add(row);
    }
    return result;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: [BoxShadow(
                color: AppColors.primary.withOpacity(0.07),
                blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Row(children: [
              const SizedBox(width: 14),
              const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Enter Registration No (e.g. TN0001)',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintStyle: GoogleFonts.sourceSans3(
                      fontSize: 14, color: AppColors.textHint),
                  ),
                  style: GoogleFonts.sourceSans3(
                    fontSize: 14, color: AppColors.textPrimary),
                  onChanged: (v) => setState(() { 
                    _query = v.trim(); 
                    if (_query.isNotEmpty) _searched = true;
                  }),
                  onSubmitted: (_) => setState(() => _searched = true),
                ),
              ),
              if (_query.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18,
                    color: AppColors.textMuted),
                  onPressed: () {
                    _controller.clear();
                    setState(() { _query = ''; _searched = false; });
                  }),
            ]),
          ),

          const SizedBox(height: 12),
          Text(_searched ? 'Search results for "$_query"' : 'Search by Registration Number or Name',
            style: GoogleFonts.sourceSans3(
              fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.bold)),

          const SizedBox(height: 20),

          // Results
          if (_searched && _query.isNotEmpty)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _churchesStream,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting && !_isUsingLocalFallback) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snap.hasError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLocalDataFallback());
                    if (_isLoadingLocal) return const Center(child: CircularProgressIndicator());
                    if (!_isUsingLocalFallback) return Center(child: Text(snap.error.toString(), style: const TextStyle(color: Colors.red), textAlign: TextAlign.center));
                  }

                  final allDocs = snap.data?.docs ?? [];
                  final List<Map<String, dynamic>> itemsToFilter = _isUsingLocalFallback 
                      ? _localData 
                      : allDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();

                  final q = _query.toLowerCase();
                  final docs = itemsToFilter.where((data) {
                    final id = (data['churchId'] ?? '').toString().toLowerCase();
                    final name = (data['pastorName'] ?? '').toString().toLowerCase();
                    return id.contains(q) || name.contains(q);
                  }).toList();
                  
                  if (docs.isEmpty) return _EmptySearch(query: _query);
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (_, i) {
                      final data = docs[i];
                      return _ChurchResultCard(data: data,
                        onTap: () => _showMemberDetails(context, data));
                    },
                  );
                },
              ),
            )
          else if (!_searched)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.church_rounded,
                      size: 64, color: AppColors.primaryLight),
                    const SizedBox(height: 16),
                    Text('Search for a Church',
                      style: GoogleFonts.merriweather(
                        fontSize: 16, fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Text('Enter a name or location\n(e.g. Madurai, TN0001, John)',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sourceSans3(
                        fontSize: 13, color: AppColors.textMuted)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showMemberDetails(BuildContext context, Map<String, dynamic> p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(margin: const EdgeInsets.only(bottom: 20), alignment: Alignment.center, child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            Row(
              children: [
                const CircleAvatar(radius: 28, backgroundColor: AppColors.primaryLight, child: Icon(Icons.person_3_rounded, color: AppColors.primary, size: 28)),
                const SizedBox(width: 16),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p['pastorName'] ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(p['churchName'] ?? '', style: const TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ],
                )),
              ],
            ),
            const SizedBox(height: 24),
            _detailRow(Icons.numbers_rounded, 'Registration No.', p['churchId'] ?? '---'),
            _detailRow(Icons.badge_rounded, 'Designation', p['designation'] ?? '---'),
            _detailRow(Icons.tag_rounded, 'Serial Number (S.No)', p['sNo'] ?? '---'),
            if (p['pastorPhone']?.toString().isNotEmpty ?? false) _detailRow(Icons.phone_rounded, 'Phone Contact', p['pastorPhone']),
            if ((p['address']?.toString() ?? '').isNotEmpty) _detailRow(Icons.location_on_rounded, 'Contact Address', p['address']),
            _detailRow(Icons.check_circle_rounded, 'Current Status', 'Active', color: AppColors.success),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color ?? AppColors.textMuted),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
              Text(value, style: TextStyle(fontSize: 14, color: color ?? AppColors.textPrimary, fontWeight: FontWeight.w500)),
            ],
          )),
        ],
      ),
    );
  }
}

// ── TAB 2: Browse by Zone ────────────────────────────────────────────────────
class _ZoneBrowseTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
        .collection('zones').snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return const Center(child: Text('No zones found'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snap.data!.docs.length,
          itemBuilder: (_, i) {
            final zone = snap.data!.docs[i].data() as Map<String, dynamic>;
            return _ZoneCard(zone: zone);
          },
        );
      },
    );
  }
}

// Zone card with expandable church list
class _ZoneCard extends StatefulWidget {
  final Map<String, dynamic> zone;
  const _ZoneCard({required this.zone});
  @override
  State<_ZoneCard> createState() => _ZoneCardState();
}
class _ZoneCardState extends State<_ZoneCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Zone header — tappable to expand
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLighter,
                    borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.location_city_rounded,
                    color: AppColors.primary, size: 20)),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.zone['zoneName'] ?? '',
                      style: GoogleFonts.merriweather(
                        fontSize: 15, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                    Text('Zone Head: ${widget.zone['headPastorName'] ?? ''}',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 12, color: AppColors.textMuted)),
                  ],
                )),
                Icon(
                  _expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textMuted),
              ]),
            ),
          ),
          // Expanded: show churches in this zone
          if (_expanded)
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                .collection('churches')
                .where('zoneId', isEqualTo: widget.zone['id'])
                .where('isActive', isEqualTo: true)
                .snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator());
                }
                if (!snap.hasData || snap.data!.docs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('No churches in this zone yet.',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 13, color: AppColors.textMuted)));
                }
                return Column(
                  children: snap.data!.docs.map((doc) {
                    final c = doc.data() as Map<String, dynamic>;
                    return _ChurchResultCard(data: c,
                      onTap: () => context.push('/churches/${c['churchId']}'));
                  }).toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}

// Church result card (used in both search and zone browse)
class _ChurchResultCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;
  const _ChurchResultCard({required this.data, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final name = (data['pastorName']?.toString().isEmpty ?? true) ? 'Unknown Pastor' : data['pastorName'].toString();
    final church = data['churchName'] ?? 'ACI Diocese Church';
    final id = data['churchId'] ?? 'ID--';
    final district = data['districtName'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.church_rounded, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, 
                            style: GoogleFonts.merriweather(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.church_rounded, size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(church, 
                                style: GoogleFonts.sourceSans3(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.normal)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            children: [
                              _miniChip(Icons.numbers_rounded, id, Colors.blueGrey),
                              if (district.isNotEmpty) _miniChip(Icons.location_on_rounded, district, Colors.orange),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  final String query;
  const _EmptySearch({required this.query});
  @override
  Widget build(BuildContext context) => Center(child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.search_off_rounded, size: 56, color: AppColors.border),
      const SizedBox(height: 14),
      Text('No church found for "$query"',
        style: GoogleFonts.merriweather(
          fontSize: 15, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary)),
      const SizedBox(height: 8),
      Text('Check the Church ID and try again.',
        style: GoogleFonts.sourceSans3(
          fontSize: 13, color: AppColors.textMuted)),
    ],
  ));
}
