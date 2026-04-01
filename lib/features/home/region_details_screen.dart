import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/aci_app_bar.dart';

class RegionDetailsScreen extends StatefulWidget {
  final String dioceseName;
  final String districtName; // 'All' or specific district
  final List<String> validDistricts;

  const RegionDetailsScreen({
    super.key,
    required this.dioceseName,
    required this.districtName,
    required this.validDistricts,
  });

  @override
  State<RegionDetailsScreen> createState() => _RegionDetailsScreenState();
}

class _RegionDetailsScreenState extends State<RegionDetailsScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ringCtrl;
  String _searchQuery = '';
  late final Stream<QuerySnapshot> _churchesStream;
  List<Map<String, dynamic>> _localData = [];
  bool _isUsingLocalFallback = false;
  bool _isLoadingLocal = false;
  
  // Hardcoded bishop mappings based on user request (mock data as requested "leave the image and name just mention bishop of [district]")
  late final String _bishopName;
  late final String _bishopTitle;

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    
    final locationName = widget.districtName == 'All' ? widget.dioceseName.replaceAll('ACI ', '') : widget.districtName;
    _bishopName = 'Bishop of $locationName';
    _bishopTitle = 'Overseer · $locationName Region';

    _churchesStream = FirebaseFirestore.instance.collection('churches').where('isActive', isEqualTo: true).snapshots();
  }

  void _showPastorDetails(BuildContext context, Map<String, dynamic> p, String initials) {
    final name = p['pastorName']?.toString() ?? 'Pastor';
    final church = p['churchName']?.toString() ?? 'Unknown Church';
    final regNo = p['churchId']?.toString() ?? 'N/A';
    final phone = p['pastorPhone']?.toString() ?? 'N/A';
    final address = p['address']?.toString() ?? 'N/A';
    final designation = p['designation']?.toString() ?? 'Pastor';
    final status = p['status']?.toString() ?? 'Active';
    
    String dob = p['pastorDob']?.toString() ?? 'N/A';
    if (dob.isNotEmpty && dob != 'N/A') {
      try {
        final pts = dob.split(RegExp(r'[/.-]'));
        if (pts.length >= 3) {
           int yr = int.parse(pts[2]);
           if (yr < 100) yr += (yr < 50 ? 2000 : 1900);
           int age = DateTime.now().year - yr;
           dob = '$dob ($age Yrs)';
        }
      } catch (_) {}
    }

    String ordination = p['dateOfOrdination']?.toString() ?? 'N/A';
    if (ordination.isNotEmpty && ordination != 'N/A') {
       final match = RegExp(r'\d{1,2}[./-]\d{1,2}[./-]\d{2,4}').firstMatch(ordination);
       if (match != null) ordination = match.group(0)!;
       else ordination = ordination.split(RegExp(r'\s+')).first;
    }
    
    final lastPaid = p['lastPaymentDate']?.toString() ?? 'N/A';
    String renewalDue = 'N/A';
    if (lastPaid != 'N/A' && lastPaid.contains('.')) {
      try {
        final parts = lastPaid.split('.');
        if (parts.length == 3) {
          int year = int.parse(parts[2]);
          renewalDue = '${parts[0]}.${parts[1]}.${year + 1}';
        }
      } catch (_) {}
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          children: [
            Container(margin: const EdgeInsets.only(top: 12, bottom: 8), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(radius: 32, backgroundColor: AppColors.primaryLight, child: Text(initials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 22))),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.textPrimary)),
                              const SizedBox(height: 4),
                              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)), child: Text(regNo, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _profileDetailRow(Icons.badge_rounded, 'Designation', designation),
                    _profileDetailRow(Icons.church_rounded, 'Church', church),
                    _profileDetailRow(Icons.calendar_month_rounded, 'Date of Birth', dob),
                    _profileDetailRow(Icons.military_tech_rounded, 'Ordination Date', ordination),
                    _profileDetailRow(Icons.phone_rounded, 'Phone', phone),
                    _profileDetailRow(Icons.location_on_rounded, 'Address', address),
                    
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    
                    const Text('Member Subscription', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(height: 12),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                      child: Column(
                        children: [
                          Row(children: [const Icon(Icons.check_circle, color: AppColors.success, size: 16), const SizedBox(width: 8), Text('Status: $status', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold))]),
                          const SizedBox(height: 12),
                          Row(children: [const Icon(Icons.payment_rounded, size: 16, color: AppColors.textMuted), const SizedBox(width: 8), Text('Last Paid: $lastPaid', style: const TextStyle(color: AppColors.textSecondary))]),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.orange.withOpacity(0.3))),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 18), const SizedBox(width: 8),
                              Text('Renewal Due: $renewalDue', style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.w900, shadows: [Shadow(color: Colors.orangeAccent.withOpacity(0.6), blurRadius: 4)])),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadLocalDataFallback() async {
    if (_isLoadingLocal || _localData.isNotEmpty) return;
    setState(() => _isLoadingLocal = true);
    
    try {
      final raw = await DefaultAssetBundle.of(context).loadString('assets/data/pastors.csv');
      final lines = _parseCsvRobust(raw);
      if (lines.isEmpty) return;

      final headers = lines[0].map((h) => h.trim().replaceAll('"', '')).toList();
      final List<Map<String, dynamic>> parsed = [];

      for (int i = 1; i < lines.length; i++) {
        final cells = lines[i];
        if (cells.isEmpty || cells.every((e) => e.isEmpty)) continue;
        
        final Map<String, dynamic> row = {};
        for (int j = 0; j < headers.length && j < cells.length; j++) {
           row[headers[j]] = cells[j];
        }
        
        final mapped = {
          'sNo': row['S.No'] ?? '',
          'churchId': row['Reg.No'] ?? '',
          'pastorName': row['Name'] ?? '',
          'churchName': row['Church Name'] ?? '',
          'districtName': row['District'] ?? row['Distirct'] ?? '',
          'zoneName': row['Zone'] ?? '',
          'pastorPhone': row['Phone No.'] ?? '',
          'designation': row['Designation'] ?? '',
          'address': row['Contact Address'] ?? '',
          'pastorDob': row['D.O.B'] ?? '',
          'dateOfOrdination': row['Date of Ordination'] ?? '',
          'status': 'Active',
          'isActive': true,
        };
        
        final churchIdStr = mapped['churchId'].toString().trim();
        if (churchIdStr.isNotEmpty && churchIdStr.length > 2) {
           parsed.add(mapped);
        }
      }
      
      setState(() {
        _localData = parsed;
        _isUsingLocalFallback = true;
        _isLoadingLocal = false;
      });
      // DEBUG PRINT to verify if TN0001 is found
      if (parsed.any((e) => e['churchId'] == 'TN0001')) {
         debugPrint('--- [OFFLINE] TN0001 successfully parsed from CSV ---');
      }
    } catch (e) {
      debugPrint('--- [OFFLINE ERROR] CSV Parsing failed: $e ---');
      setState(() => _isLoadingLocal = false);
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
        // Look ahead for double quotes "" (escaped quote)
        if (i + 1 < raw.length && raw[i + 1] == '"') {
           buf.write('"');
           i++;
        } else {
           inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        row.add(buf.toString().trim());
        buf.clear();
      } else if ((char == '\n' || char == '\r') && !inQuotes) {
        if (char == '\r' && i + 1 < raw.length && raw[i + 1] == '\n') i++;
        row.add(buf.toString().trim());
        if (row.isNotEmpty && row.any((e) => e.isNotEmpty)) {
           result.add(List.from(row));
        }
        row.clear();
        buf.clear();
      } else {
        buf.write(char);
      }
    }
    // Final buffer
    if (buf.isNotEmpty || row.isNotEmpty) {
      row.add(buf.toString().trim());
      result.add(row);
    }
    return result;
  }

  void _showChurchDetails(BuildContext context, Map<String, dynamic> p, String churchName) {
    final address = p['address']?.toString() ?? '';
    final dist = p['districtName']?.toString() ?? 'the region';
    final desc = 'This church is located in $dist. Join us for worship and experience the power of faith and community.';
    
    showModalBottomSheet(
      context: context,
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
                    Text(p['pastorName'] ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(churchName, style: const TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ],
                )),
              ],
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              child: Column(
                children: [
                   _detailRow(Icons.numbers_rounded, 'Registration No.', p['churchId'] ?? '---'),
                   _detailRow(Icons.badge_rounded, 'Designation', p['designation'] ?? '---'),
                   _detailRow(Icons.tag_rounded, 'Serial Number (S.No)', p['sNo'] ?? '---'),
                   if (p['pastorPhone']?.toString().isNotEmpty ?? false) _detailRow(Icons.phone_rounded, 'Phone Contact', p['pastorPhone']),
                   if (address.isNotEmpty) _detailRow(Icons.location_on_rounded, 'Contact Address', address),
                   _detailRow(Icons.check_circle_rounded, 'Current Status', p['status'] ?? 'Active', color: AppColors.success),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                icon: const Icon(Icons.directions_rounded),
                label: const Text('Get Directions', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () async {
                   final query = Uri.encodeComponent('$churchName, $address');
                   final url = Uri.parse('https://maps.google.com/?q=$query');
                   try { await launchUrl(url, mode: LaunchMode.externalApplication); } catch (_) {}
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _profileDetailRow(IconData icon, String label, String value) {
    if (value.isEmpty || value == 'N/A') return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.districtName == 'All' ? widget.dioceseName : widget.districtName, 
          style: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
        actions: [
          if (_isUsingLocalFallback)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Tooltip(
                message: 'Local Offline Data',
                child: Icon(Icons.cloud_off_rounded, color: Colors.orange, size: 20),
              ),
            ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // ── SEARCH BOX ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                    decoration: InputDecoration(
                      hintText: 'Search by ID Number, Pastor, or Church...',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primaryLight)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primaryLight)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          
          // ── PASTORS LIST STREAM ──
          StreamBuilder<QuerySnapshot>(
            stream: _churchesStream,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting && !_isUsingLocalFallback) {
                return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
              }
              
              if (snap.hasError) {
                // If it fails with permission-denied (or any error), automatically switch to local CSV
                WidgetsBinding.instance.addPostFrameCallback((_) => _loadLocalDataFallback());
                
                if (_isLoadingLocal) {
                    return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                }
                
                if (!_isUsingLocalFallback) {
                   return SliverFillRemaining(child: Padding(padding: const EdgeInsets.all(16), child: Center(child: Text(snap.error.toString(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)))));
                }
              }
              
              final allDocs = snap.data?.docs ?? [];
              
              // If we have firestore data, use it. Otherwise, use our local fallback data.
              final List<Map<String, dynamic>> itemsToFilter = _isUsingLocalFallback 
                  ? _localData 
                  : allDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
              
              final filteredDocs = itemsToFilter.where((data) {
                final dist = data['districtName']?.toString() ?? '';
                if (widget.districtName == 'All') {
                  if (!widget.validDistricts.contains(dist) && dist.isNotEmpty) return false;
                } else {
                  if (dist.toLowerCase() != widget.districtName.toLowerCase()) return false;
                }

                final pName = (data['pastorName'] ?? '').toString().toLowerCase();
                final cName = (data['churchName'] ?? '').toString().toLowerCase();
                final cId = (data['churchId'] ?? '').toString().toLowerCase();
                final matchesSearch = pName.contains(_searchQuery) || cName.contains(_searchQuery) || cId.contains(_searchQuery);
                return matchesSearch;
              }).toList();

              return SliverMainAxisGroup(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Available Churches & Pastors', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20)),
                            child: Text('${filteredDocs.length} Pastors & 1 Bishop', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: filteredDocs.isEmpty
                      ? const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(32), child: Text('No pastors found in this region.', style: TextStyle(color: AppColors.textMuted)))))
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              final p = filteredDocs[i];
                              final rawName = p['pastorName']?.toString() ?? 'Pastor';
                              final name = (rawName.isEmpty) ? 'Unknown' : rawName.replaceAll('Rev. ', '').replaceAll('Pr. ', '');
                              final church = p['churchName']?.toString() ?? 'Unknown Church';
                              final dist = p['districtName']?.toString() ?? '';
                              
                              String initials = 'PR';
                              final letters = name.replaceAll(RegExp(r'[^a-zA-Z]'), '').trim();
                              if (letters.length >= 2) initials = letters.substring(0, 2).toUpperCase();

                              final isSearching = _searchQuery.isNotEmpty;

                              if (isSearching) {
                                // Show Pastor Details when searched
                                return InkWell(
                                  onTap: () => _showPastorDetails(context, p, initials),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                                    child: Row(
                                      children: [
                                        CircleAvatar(radius: 24, backgroundColor: AppColors.primaryLight, child: Text(initials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                                              const SizedBox(height: 4),
                                              Text('${p['churchId'] ?? 'ID N/A'} • ${p['designation'] ?? 'Pastor'}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                // ── PREMIUM STRUCTURED CHURCH CARD ──
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppColors.border.withOpacity(0.5)),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => _showChurchDetails(context, p, church),
                                      borderRadius: BorderRadius.circular(16),
                                      child: Column(
                                        children: [
                                          // Header Section
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 52, height: 52,
                                                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                                                  child: const Icon(Icons.church_rounded, color: AppColors.primary, size: 28),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.textPrimary)),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          const Icon(Icons.church_rounded, size: 14, color: AppColors.primary),
                                                          const SizedBox(width: 4),
                                                          Text(church, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.normal)),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Wrap(
                                                        spacing: 8,
                                                        children: [
                                                          _miniChip(Icons.numbers_rounded, p['churchId'] ?? 'ID--', Colors.blueGrey),
                                                          if (dist.isNotEmpty) _miniChip(Icons.location_on_rounded, dist, Colors.orange),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Footer Action
                                          Divider(height: 1, color: AppColors.border.withOpacity(0.5)),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text('View Church Profile', style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                                                Row(
                                                  children: [
                                                    TextButton.icon(
                                                      onPressed: () { /* Map launch duplicated in detail popup */ },
                                                      icon: const Icon(Icons.directions_rounded, size: 16),
                                                      label: const Text('Directions', style: TextStyle(fontSize: 13)),
                                                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
                                                    ),
                                                    const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textMuted),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            childCount: filteredDocs.length,
                          ),
                        ),
                  ),
                ],
              );
            },
          ),
        ],
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
