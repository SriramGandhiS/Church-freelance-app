import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/watermark_scaffold.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});
  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  String _purpose = 'General Offering';
  double _amount = 500;
  bool _custom = false;
  final _customCtrl = TextEditingController();

  final _purposes = ['Tithe', 'Event Fund', 'Building Fund', 'General Offering'];
  final _amounts = [100.0, 500.0, 1000.0, 2000.0, 5000.0];

  @override
  Widget build(BuildContext context) {
    return WatermarkScaffold(appBar: AppBar(title: const Text('Support ACI Diocese')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Purpose', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.5,
          children: _purposes.map((p) {
            final sel = _purpose == p;
            return GestureDetector(onTap: () => setState(() => _purpose = p), child: Container(
              decoration: BoxDecoration(color: sel ? AppColors.primaryLight : AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: sel ? AppColors.primary : AppColors.border, width: sel ? 2 : 1)),
              child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                if (sel) const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.primary),
                if (sel) const SizedBox(width: 6),
                Text(p, style: TextStyle(fontWeight: FontWeight.w600, color: sel ? AppColors.primary : AppColors.textSecondary, fontSize: 14)),
              ]))));
          }).toList()),
        const SizedBox(height: 24),
        Text('Amount (\u20b9)', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: [
          ..._amounts.map((a) { final sel = _amount == a && !_custom;
            return ChoiceChip(label: Text('\u20b9${a.toInt()}'), selected: sel, selectedColor: AppColors.primary, labelStyle: TextStyle(color: sel ? Colors.white : AppColors.primary, fontWeight: FontWeight.bold),
              backgroundColor: AppColors.primaryLighter, onSelected: (_) => setState(() { _amount = a; _custom = false; })); }),
          ChoiceChip(label: const Text('Custom'), selected: _custom, selectedColor: AppColors.primary, labelStyle: TextStyle(color: _custom ? Colors.white : AppColors.primary, fontWeight: FontWeight.bold),
            backgroundColor: AppColors.primaryLighter, onSelected: (_) => setState(() => _custom = true)),
        ]),
        if (_custom) ...[
          const SizedBox(height: 12),
          TextField(controller: _customCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Enter amount', prefixText: '\u20b9 '),
            onChanged: (v) => _amount = double.tryParse(v) ?? 0),
        ],
        const SizedBox(height: 24),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.lavenderLighter, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            const Icon(Icons.info_outline_rounded, color: AppColors.lavender, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text('Your offering supports the ministry and pastors of ACI Diocese.', style: Theme.of(context).textTheme.bodySmall)),
          ])),
        const SizedBox(height: 32),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: () { final amt = _custom ? (double.tryParse(_customCtrl.text) ?? 0) : _amount;
            if (amt <= 0) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid amount.'))); return; }
            context.push('/donate/qr?amount=${amt.toInt()}&purpose=$_purpose'); },
          child: const Text('Proceed to Pay'))),
        const SizedBox(height: 40),
      ])));
  }
}
