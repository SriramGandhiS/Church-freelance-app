import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  static const _pastors = [
    {'id': 'selvin', 'name': 'Pr. Selvin Durai', 'role': 'District Overseer', 'region': 'Dindigul Central', 'phone': '9944107042', 'init': 'SD'},
    {'id': 'david', 'name': 'Pr. David Durai', 'role': 'Senior Minister', 'region': 'Dindigul North', 'phone': '9876543210', 'init': 'DD'},
    {'id': 'thaaveethu', 'name': 'Pr. Y. Thaaveethu', 'role': 'Senior Minister', 'region': 'Vadipatti', 'phone': '9876500013', 'init': 'YT'},
    {'id': 'baby_thomas', 'name': 'Pr. Baby Thomas', 'role': 'Committee Member', 'region': 'Dindigul South', 'phone': '9876500001', 'init': 'BT'},
    {'id': 't_christudhas', 'name': 'Pr. T. Christudhas', 'role': 'Committee Member', 'region': 'Natham', 'phone': '9876500002', 'init': 'TC'},
    {'id': 'pg_roy', 'name': 'Pr. P. G. Roy', 'role': 'Committee Member', 'region': 'Vedasandur', 'phone': '9876500003', 'init': 'PG'},
    {'id': 'jeyabalan', 'name': 'Pr. Jeyabalan J Devapitchai', 'role': 'Committee Member', 'region': 'Devakottai', 'phone': '9876500004', 'init': 'JJ'},
    {'id': 'victor', 'name': 'Pr. Victor Joseph', 'role': 'Committee Member', 'region': 'Palani', 'phone': '9876500005', 'init': 'VJ'},
    {'id': 'mariya', 'name': 'Pr. Mariya Susai', 'role': 'Committee Member', 'region': 'Oddanchatram', 'phone': '9876500006', 'init': 'MS'},
    {'id': 'd_christudas', 'name': 'Pr. D. Christudas', 'role': 'Committee Member', 'region': 'Batlagundu', 'phone': '9876500007', 'init': 'DC'},
    {'id': 'ms_john', 'name': 'Pr. M. S. John Rathina Singh', 'role': 'District Overseer', 'region': 'Madurai', 'phone': '9876500008', 'init': 'MJ'},
    {'id': 'george', 'name': 'Pr. G. George Ananth', 'role': 'Committee Member', 'region': 'Dindigul East', 'phone': '9876500009', 'init': 'GG'},
    {'id': 'johnson_d', 'name': 'Pr. Johnson P. Daniel', 'role': 'Committee Member', 'region': 'Nilakottai', 'phone': '9876500010', 'init': 'JP'},
    {'id': 'solomon', 'name': 'Pr. Solomon Kennedy', 'role': 'Committee Member', 'region': 'Kodaikanal', 'phone': '9876500011', 'init': 'SK'},
    {'id': 'thomson', 'name': 'Pr. Thomson Mathews', 'role': 'Committee Member', 'region': 'Periyakulam', 'phone': '9876500012', 'init': 'TM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: const Text('Our Pastors'), centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.canPop() ? context.pop() : context.go('/home'))),
      body: ListView.builder(padding: const EdgeInsets.all(16), itemCount: _pastors.length, itemBuilder: (_, i) {
        final p = _pastors[i];
        final color = [AppColors.primary, AppColors.lavender, AppColors.blush, AppColors.sage][i % 4];
        return GestureDetector(onTap: () => context.push('/members/${p['id']}'),
          child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              CircleAvatar(radius: 24, backgroundColor: color.withValues(alpha: 0.15),
                child: Text(p['init']!, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14))),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(p['role']!, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
                Text(p['region']!, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ])),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
            ])));
      }),
    );
  }
}
