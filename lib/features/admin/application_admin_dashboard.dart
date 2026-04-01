import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../../core/constants/app_colors.dart';
import 'application_model.dart';
import 'application_admin_service.dart';

class ApplicationAdminDashboard extends StatefulWidget {
  const ApplicationAdminDashboard({super.key});

  @override
  State<ApplicationAdminDashboard> createState() => _DashState();
}

class _DashState extends State<ApplicationAdminDashboard> {
  List<ApplicationRecord> _all = [];
  List<ApplicationRecord> _filtered = [];
  bool _loading = true;
  bool _syncing = false;
  String? _errorMessage;
  String _search = '';
  String _filter = 'All';

  @override
  void initState() { super.initState(); _load(isSilent: false); }

  Future<void> _load({bool isSilent = true}) async {
    if (!isSilent) setState(() { _loading = true; _errorMessage = null; });
    else setState(() => _syncing = true);
    
    try {
      final data = await ApplicationAdminService.fetchAll();
      if (mounted) {
        final Map<String, ApplicationRecord> unique = {};
        for (final r in data) {
          if (r.id.isEmpty || r.name.isEmpty) continue; 
          unique[r.phone.isNotEmpty ? r.phone : r.id] = r; // Strict dedup by phone or ID
        }
        setState(() { 
          _all = unique.values.toList(); 
          _loading = false; 
          _syncing = false;
        });
        _applyFilter();
      }
    } catch (e) {
      if (mounted) setState(() { _loading = false; _syncing = false; _errorMessage = e.toString(); });
    }
  }

  void _applyFilter() {
    setState(() {
      _filtered = _all.where((r) {
        final matchSearch = _search.isEmpty ||
            r.name.toLowerCase().contains(_search.toLowerCase()) ||
            r.phone.contains(_search) ||
            r.id.toLowerCase().contains(_search.toLowerCase());
        final matchFilter = _filter == 'All' || r.paymentStatus == _filter;
        return matchSearch && matchFilter;
      }).toList();
      _filtered.sort((a, b) => b.id.compareTo(a.id));
    });
  }

  Future<void> _verifyPayment(int index) async {
    final record = _filtered[index];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Verify Payment'),
        content: Text('Mark payment as VERIFIED for ${record.name}? This will instantly flash sync to the cloud.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Verify ✓', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ApplicationAdminService.verify(record.id);
      final updated = record.copyWith(verificationStatus: 'VERIFIED');
      setState(() {
        final idx = _all.indexWhere((r) => r.id == record.id);
        if (idx != -1) _all[idx] = updated;
        _applyFilter();
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment verified & synchronized ✓'), backgroundColor: AppColors.success));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
    }
  }

  bool _isRecent(String ts) {
    final today = DateTime.now();
    final dayStr = today.day.toString().padLeft(2, '0');
    return ts.contains('$dayStr-');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _all.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
          CircularProgressIndicator(color: Colors.white), SizedBox(height: 24),
          Text('Establishing Secure Flash Sync...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ])),
      );
    }

    final total = _all.length;
    final paid = _all.where((r) => r.paymentStatus == 'PAID').length;
    final pending = total - paid;
    final verified = _all.where((r) => r.verificationStatus == 'VERIFIED').length;
    final recent = _all.where((r) => _isRecent(r.timestamp)).length;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => _load(isSilent: true),
        icon: _syncing 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
            : const Icon(Icons.sync_rounded, color: Colors.white),
        label: Text(_syncing ? 'Syncing...' : 'Flash Sync', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(child: Column(children: [
        _header(context),
        if (recent > 0) _recentBanner(recent),
        _statGrid(total, paid, pending, verified),
        const SizedBox(height: 8),
        _searchBar(),
        Expanded(child: _body()),
      ])),
    );
  }

  Widget _header(BuildContext ctx) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => ctx.canPop() ? ctx.pop() : ctx.go('/home'),
          padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
        const SizedBox(width: 8),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Dashboard', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
          Text('Real-time Administration', style: TextStyle(color: Colors.white70, fontSize: 13)),
        ])),
        if (_syncing) const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
        IconButton(
          onPressed: () => launchUrl(Uri.parse('https://docs.google.com/spreadsheets/d/1MmeGsWUQL2vUYS0BAzHUnXA5UMjpno1nMweO1dCqZ7w/edit?gid=445259978#gid=445259978'), mode: LaunchMode.externalApplication),
          icon: const Icon(Icons.table_view_rounded, color: Colors.white),
          tooltip: 'Open Google Sheets',
        ),
      ]),
    );
  }

  Widget _recentBanner(int count) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: AppColors.sage.withValues(alpha: 0.15),
      child: Row(children: [
        const Icon(Icons.notifications_active_rounded, color: AppColors.sage, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text('$count new registration(s) today!', style: const TextStyle(color: AppColors.sage, fontWeight: FontWeight.bold, fontSize: 13))),
      ]),
    );
  }

  Widget _statGrid(int total, int paid, int pending, int verified) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(children: [
        Expanded(child: Column(children: [
          Row(children: [
            _statBox('Total Members', total.toString(), Icons.people_rounded, AppColors.primary),
            const SizedBox(width: 12),
            _statBox('Paid', paid.toString(), Icons.payments_rounded, AppColors.success),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            _statBox('Pending', pending.toString(), Icons.pending_actions_rounded, AppColors.error),
            const SizedBox(width: 12),
            _statBox('Verified', verified.toString(), Icons.verified_user_rounded, Colors.blue),
          ]),
        ])),
      ]),
    );
  }

  Widget _statBox(String label, String val, IconData ic, Color c) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: c.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: c.withValues(alpha: 0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Icon(ic, color: c, size: 22),
          Text(val, style: TextStyle(color: c, fontSize: 24, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
        ]),
        const SizedBox(height: 12),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    ));
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        Expanded(child: TextField(
          onChanged: (v) { _search = v; _applyFilter(); },
          decoration: InputDecoration(
            hintText: 'Search ID, name, phone...', hintStyle: const TextStyle(fontSize: 13),
            prefixIcon: const Icon(Icons.search_rounded, size: 20),
            filled: true, fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        )),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isDense: true, value: _filter,
              items: ['All', 'PAID', 'PENDING'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)))).toList(),
              onChanged: (v) { setState(() => _filter = v!); _applyFilter(); },
            ),
          ),
        ),
      ]),
    );
  }

  Widget _body() {
    if (_errorMessage != null) return Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 56), const SizedBox(height: 16),
      Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
    ])));
    
    if (_filtered.isEmpty) return const Center(child: Text('No applications match your sync filters.', style: TextStyle(color: AppColors.textMuted)));

    return RefreshIndicator(
      color: AppColors.primary, onRefresh: () => _load(isSilent: true),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // padding for FAB
        itemCount: _filtered.length,
        itemBuilder: (_, i) => _card(i),
      ),
    );
  }

  Widget _card(int i) {
    final r = _filtered[i];
    final isPaid = r.paymentStatus == 'PAID';
    final isVerified = r.verificationStatus == 'VERIFIED';
    final isNew = _isRecent(r.timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.all(16),
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.white,
            title: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CircleAvatar(backgroundColor: isPaid ? AppColors.successLight : AppColors.errorLight, radius: 22,
                child: Text(r.name.isNotEmpty ? r.name[0].toUpperCase() : '?',
                  style: TextStyle(color: isPaid ? AppColors.success : AppColors.error, fontWeight: FontWeight.bold, fontSize: 18))),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(r.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16))),
                  if (isNew) Container(
                    margin: const EdgeInsets.only(left: 8), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.sage, borderRadius: BorderRadius.circular(8)),
                    child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ]),
                const SizedBox(height: 4),
                Text(r.id, style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontFamily: 'monospace')),
                const SizedBox(height: 6),
                Row(children: [
                  _badge(isPaid ? 'PAID' : 'PENDING', isPaid ? AppColors.success : AppColors.error, isPaid ? AppColors.successLight : AppColors.errorLight),
                  const SizedBox(width: 8),
                  _badge(isVerified ? 'VERIFIED' : 'UNVERIFIED', isVerified ? Colors.blue : AppColors.warning, isVerified ? Colors.blue.withValues(alpha: 0.1) : AppColors.warningLight),
                ]),
              ])),
            ]),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: AppColors.scaffold, border: Border(top: BorderSide(color: AppColors.border))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Detailed Functions & Info', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13)),
                  const SizedBox(height: 16),
                  _detailRow('Phone', r.phone),
                  _detailRow('Email', r.fullJson['email']?.toString() ?? 'N/A'),
                  _detailRow('Church', r.church),
                  _detailRow('Address', r.address),
                  _detailRow('Ministry Function', r.ministryType),
                  _detailRow('Payment ID', r.paymentId),
                  _detailRow('Registered On', r.timestamp),
                  const SizedBox(height: 20),
                  
                  if (!isVerified)
                    SizedBox(width: double.infinity, child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                      icon: const Icon(Icons.verified_rounded),
                      label: const Text('Mark as Verified in Database'),
                      onPressed: () => _verifyPayment(i),
                    )),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String text, Color fg, Color bg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
    child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: fg)),
  );

  Widget _detailRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textHint, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
      ]),
    );
  }
}
