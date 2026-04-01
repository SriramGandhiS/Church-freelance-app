import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import 'synod_service.dart';

// ─────────────────────────────────────────────────────────
// DATA — hardcoded Reg_No for bulletproof matching
// ─────────────────────────────────────────────────────────

class SynodCouncilMember {
  final String regNo;        // exact match key from sheet
  final String displayName;
  final String role;
  final String? imagePath;

  const SynodCouncilMember({
    required this.regNo,
    required this.displayName,
    required this.role,
    this.imagePath,
  });
}

const _generalCouncilMembers = [
  SynodCouncilMember(
    regNo: 'TN0001',
    displayName: 'The Most Rev. Johnson Durai',
    role: 'President / Chairman',
    imagePath: 'assets/images/synod/jhonsondurai.jpeg',
  ),
  SynodCouncilMember(
    regNo: 'TN0005',
    displayName: 'Dr. John Durai',
    role: 'Vice Chairman',
    imagePath: 'assets/images/synod/Jhon durai.jpeg',
  ),
  SynodCouncilMember(
    regNo: 'TN0093',
    displayName: 'Dr. Suresh Daniel',
    role: 'Financial Treasurer',
    imagePath: 'assets/images/synod/Suresh daniel.jpeg',
  ),
  SynodCouncilMember(
    regNo: 'TN0146',
    displayName: 'Rev. J.A.D. Samuel',
    role: 'General Secretary',
    imagePath: 'assets/images/synod/J A D Samuvel.jpeg',
  ),
  SynodCouncilMember(
    regNo: 'TN0058',
    displayName: 'Rev. John Samuel',
    role: 'Bishop Commissionar',
    imagePath: 'assets/images/synod/John Samuvel.jpeg',
  ),
];

const _academicMembers = [
  // User's specific top 5 list
  SynodCouncilMember(
    regNo: 'TN0012', 
    displayName: 'Rev. R. Gnana Inbavanan',      
    role: 'Synod Academic Member',
    imagePath: 'assets/images/synod/gnana inbavan.jpeg',
  ),
  SynodCouncilMember(
    regNo: 'TN0010', 
    displayName: 'Rev. M. Sathish Kumar',        
    role: 'Synod Academic Member',
    imagePath: 'assets/images/synod/satheesh.jpeg',
  ),
  SynodCouncilMember(
    regNo: 'TN0667', 
    displayName: 'Rev. J. Joseph',               
    role: 'Synod Academic Member',
    imagePath: 'assets/images/synod/joseph J.jpeg',
  ),
  SynodCouncilMember(
    regNo: 'TN0661', 
    displayName: 'Rev. J. Shyam Raj',            
    role: 'Synod Academic Member',
    imagePath: 'assets/images/synod/shyam.jpeg',
  ),
  SynodCouncilMember(
    regNo: 'TN0714', 
    displayName: 'Rev. S. Moses Prawin paul',    
    role: 'Synod Academic Member',
    imagePath: 'assets/images/synod/moses prawin.jpeg',
  ),
  
  // The 5 additional new members the user provided
  SynodCouncilMember(
    regNo: 'TN0007', 
    displayName: 'Rt. Rev. A. Pounraj',           
    role: 'Synod Academic Member',
    imagePath: 'assets/images/synod/pounraj.jpeg',
  ),
  SynodCouncilMember(
    regNo: 'TN0413', 
    displayName: 'Rev. S. Anand',                 
    role: 'Synod Academic Member',
    imagePath: 'assets/images/synod/anand.jpeg',
  ),
  SynodCouncilMember(
    regNo: 'TN0214', 
    displayName: 'Rt. Rev. G. Edwin Joseph Selvaraj', 
    role: 'Synod Academic Member',
    imagePath: 'assets/images/synod/edwin.jpeg',
  ),
  SynodCouncilMember(
    regNo: 'TN0587', 
    displayName: 'Rev. D. V. Isaac Timothy',      
    role: 'Synod Academic Member',
    imagePath: 'assets/images/synod/isaac.jpeg',
  ),
  SynodCouncilMember(
    regNo: 'TN0607', 
    displayName: 'Rev. J. Xavier Paulraj',        
    role: 'Synod Academic Member',
    imagePath: 'assets/images/synod/xavier.jpeg',
  ),
  
  // The 5 General Council members copied over to Academic list
  SynodCouncilMember(
    regNo: 'TN0001', 
    displayName: 'The Most Rev. Johnson Durai',   
    role: 'Synod Academic Member',
    imagePath: 'assets/images/synod/jhonsondurai.jpeg',
  ),
  SynodCouncilMember(
    regNo: 'TN0005', 
    displayName: 'Dr. John Durai',                
    role: 'Synod Academic Member',
    imagePath: 'assets/images/synod/Jhon durai.jpeg',
  ),
  SynodCouncilMember(
    regNo: 'TN0093', 
    displayName: 'Dr. Suresh Daniel',             
    role: 'Synod Academic Member',
    imagePath: 'assets/images/synod/Suresh daniel.jpeg',
  ),
  SynodCouncilMember(
    regNo: 'TN0146', 
    displayName: 'Rev. J.A.D. Samuel',            
    role: 'Synod Academic Member',
    imagePath: 'assets/images/synod/J A D Samuvel.jpeg',
  ),
  SynodCouncilMember(
    regNo: 'TN0058', 
    displayName: 'Rev. John Samuel',              
    role: 'Synod Academic Member',
    imagePath: 'assets/images/synod/John Samuvel.jpeg',
  ),
];

// ─────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────

class SynodScreen extends StatefulWidget {
  const SynodScreen({super.key});

  @override
  State<SynodScreen> createState() => _SynodScreenState();
}

class _SynodScreenState extends State<SynodScreen> {
  late Future<List<Map<String, dynamic>>> _synodDataFuture;

  @override
  void initState() {
    super.initState();
    _synodDataFuture = SynodService.fetchSynodMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('Synod Council',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/home'),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _synodDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          final List<Map<String, dynamic>> sheetData = snapshot.data ?? [];

          // Pre-build a quick lookup map by Reg_No for O(1) access
          final Map<String, Map<String, dynamic>> regLookup = {};
          for (final row in sheetData) {
            final reg = (row['Reg_No'] ?? '').toString().trim();
            if (reg.isNotEmpty) {
              regLookup[reg] = row;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  title: 'Synod General Council',
                  icon: Icons.account_balance_rounded,
                  color: Colors.amber.shade700,
                ),
                const SizedBox(height: 16),
                _PremiumMemberGroup(
                  members: _generalCouncilMembers, 
                  color: Colors.amber.shade700,
                  regLookup: regLookup,
                ),
                const SizedBox(height: 32),
                _SectionHeader(
                  title: 'Synod Academic',
                  icon: Icons.school_rounded,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                _PremiumMemberGroup(
                  members: _academicMembers, 
                  color: AppColors.primary,
                  regLookup: regLookup,
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color.withOpacity(0.13),
            borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 24),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Text(title,
            style: const TextStyle(
                fontSize: 19, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────
// PREMIUM MEMBER GROUP 
// ─────────────────────────────────────────────────────────

class _PremiumMemberGroup extends StatelessWidget {
  final List<SynodCouncilMember> members;
  final Color color;
  final Map<String, Map<String, dynamic>> regLookup;

  const _PremiumMemberGroup({required this.members, required this.color, required this.regLookup});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < members.length; i++) ...[
          _PremiumMemberTile(
            member: members[i], 
            index: i, 
            themeColor: color,
            regLookup: regLookup,
          ),
          if (i < members.length - 1) const SizedBox(height: 16),
        ]
      ],
    );
  }
}

class _PremiumMemberTile extends StatefulWidget {
  final SynodCouncilMember member;
  final int index;
  final Color themeColor;
  final Map<String, Map<String, dynamic>> regLookup;

  const _PremiumMemberTile({required this.member, required this.index, required this.themeColor, required this.regLookup});

  @override
  State<_PremiumMemberTile> createState() => _PremiumMemberTileState();
}

class _PremiumMemberTileState extends State<_PremiumMemberTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
      vsync: this, duration: Duration(milliseconds: 600 + widget.index * 100))
    ..forward();
  late final Animation<double> _fade =
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
  late final Animation<Offset> _slide = Tween<Offset>(
          begin: const Offset(0, 0.2), end: Offset.zero)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0].substring(0, 2).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // SIMPLE: lookup by exact Reg_No — no string matching, no regex
    Map<String, dynamic>? match;
    if (widget.member.regNo.isNotEmpty) {
      match = widget.regLookup[widget.member.regNo];
    }

    // Always show the hardcoded displayName and role — sheet data is for the detail popup only
    final tileName = widget.member.displayName;
    final tileRole = widget.member.role;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.themeColor.withOpacity(0.12),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: widget.themeColor.withOpacity(0.15), width: 1),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _showDetails(context, match, widget.member),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: [
                    Hero(
                      tag: 'avatar_${widget.member.displayName}',
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: widget.themeColor.withOpacity(0.3), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: widget.themeColor.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          image: widget.member.imagePath != null
                              ? DecorationImage(
                                  image: AssetImage(widget.member.imagePath!),
                                  fit: BoxFit.cover,
                                  alignment: const Alignment(0, -0.6),
                                )
                              : null,
                          gradient: widget.member.imagePath == null
                              ? LinearGradient(
                                  colors: [
                                    widget.themeColor.withOpacity(0.7),
                                    widget.themeColor
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                        ),
                        alignment: widget.member.imagePath == null ? Alignment.center : null,
                        child: widget.member.imagePath == null
                            ? Text(_initials(widget.member.displayName),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24))
                            : null,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tileName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.themeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tileRole.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: widget.themeColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right_rounded,
                        color: widget.themeColor, size: 22),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, Map<String, dynamic>? p, SynodCouncilMember memberItem) {
    if (p == null) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => Container(
          padding: const EdgeInsets.all(32),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            memberItem.imagePath != null
                ? CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(memberItem.imagePath!),
                  )
                : const Icon(Icons.person_search_rounded, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(memberItem.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 4),
            Text(memberItem.role, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text('Details not yet available in the sheet.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted)),
          ]),
        ),
      );
      return;
    }

    // Map properties from the Google Sheet columns
    final name = p['Name']?.toString() ?? memberItem.displayName;
    final church = p['Church_Name']?.toString() ?? '';
    final regNo = p['Reg_No']?.toString() ?? '';
    final phone = p['Phone']?.toString() ?? '';
    final address = p['Address']?.toString() ?? '';
    final designation = p['Designation']?.toString() ?? memberItem.role;
    final office = p['Office']?.toString() ?? '';
    final email = p['Email']?.toString() ?? '';
    final district = p['District']?.toString() ?? '';
    final state = p['State']?.toString() ?? '';
    final dob = p['DOB']?.toString() ?? '';
    final ordination = p['Date_of_Ordination']?.toString() ?? '';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(children: [
          Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2))),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: widget.themeColor.withOpacity(0.3), width: 2),
                        image: memberItem.imagePath != null
                            ? DecorationImage(
                                image: AssetImage(memberItem.imagePath!),
                                fit: BoxFit.cover,
                                alignment: const Alignment(0, -0.6),
                              )
                            : null,
                        gradient: memberItem.imagePath == null
                             ? LinearGradient(
                                colors: [
                                  widget.themeColor.withOpacity(0.7),
                                  widget.themeColor
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                      ),
                      alignment: memberItem.imagePath == null ? Alignment.center : null,
                      child: memberItem.imagePath == null
                          ? Text(_initials(name),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24))
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                    color: AppColors.textPrimary)),
                            const SizedBox(height: 4),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(regNo.isNotEmpty ? regNo : 'Member',
                                    style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13))),
                          ]),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _row(Icons.badge_rounded, 'Role', memberItem.role),
                  _row(Icons.work_rounded, 'Designation', designation),
                  _row(Icons.business_rounded, 'Office', office),
                  _row(Icons.church_rounded, 'Church', church),
                  _row(Icons.calendar_month_rounded, 'Date of Birth', dob),
                  _row(Icons.military_tech_rounded, 'Ordination Date', ordination),
                  _row(Icons.phone_rounded, 'Phone', phone),
                  _row(Icons.email_rounded, 'Email', email),
                  _row(Icons.location_on_rounded, 'Address', address),
                  _row(Icons.map_rounded, 'District', district),
                  _row(Icons.flag_rounded, 'State', state),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    if (value.isEmpty || value == 'N/A' || value == 'nan') return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 16),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600)),
            ])),
      ]),
    );
  }
}
