import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class BillLine {
  final String label;
  final int amount;
  const BillLine(this.label, this.amount);
}

/// Screen 3: Pay maintenance bill.
class PayBillScreen extends StatefulWidget {
  const PayBillScreen({super.key});

  @override
  State<PayBillScreen> createState() => _PayBillScreenState();
}

class _PayBillScreenState extends State<PayBillScreen> {
  // Mock data. Replace with GET /bills/current later.
  static const _lines = [
    BillLine('Maintenance', 2800),
    BillLine('Water', 350),
    BillLine('Sinking fund', 300),
    BillLine('Late fee', 0),
  ];
  static const _methods = [
    ('📲', 'UPI', 'Google Pay, PhonePe, Paytm'),
    ('💳', 'Card', 'Credit or debit card'),
    ('🏦', 'Net banking', 'All major banks'),
  ];

  int _method = 0;
  int get _total => _lines.fold(0, (sum, l) => sum + l.amount);

  String _rupees(int v) {
    final s = v.toString();
    if (s.length <= 3) return '₹$s';
    final head = s.substring(0, s.length - 3);
    final grouped = head.replaceAllMapped(
        RegExp(r'(\d)(?=(\d{2})+$)'), (m) => '${m[1]},');
    return '₹$grouped,${s.substring(s.length - 3)}';
  }

  void _pay() {
    // TODO: open Razorpay checkout with the chosen method
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Paying ${_rupees(_total)} via ${_methods[_method].$2}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: Text('Oct 2026 bill',
            style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          AppCard(
            child: Column(
              children: [
                for (final l in _lines) _row(text, l.label, _rupees(l.amount)),
                const Divider(height: 24, color: AppColors.line),
                _row(text, 'Total', _rupees(_total), bold: true),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Pay with',
              style: text.bodyMedium?.copyWith(
                  color: AppColors.mute, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          for (var i = 0; i < _methods.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => setState(() => _method = i),
                child: AppCard(
                  borderColor: _method == i ? AppColors.primary : null,
                  child: Row(
                    children: [
                      Text(_methods[i].$1, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_methods[i].$2,
                                style: text.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                            Text(_methods[i].$3,
                                style: text.bodySmall
                                    ?.copyWith(color: AppColors.mute)),
                          ],
                        ),
                      ),
                      if (_method == i)
                        const Icon(Icons.check_circle, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: _pay,
          child: Text('Pay ${_rupees(_total)}'),
        ),
      ),
    );
  }

  Widget _row(TextTheme text, String label, String value, {bool bold = false}) {
    final style = bold
        ? text.titleMedium?.copyWith(fontWeight: FontWeight.w800)
        : text.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value,
              style: bold
                  ? style?.copyWith(color: AppColors.primary)
                  : style?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
