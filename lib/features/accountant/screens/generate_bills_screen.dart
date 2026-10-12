import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

/// Module 3: Accounts & Billing - Batch Generate Maintenance Bills
class GenerateBillsScreen extends StatefulWidget {
  const GenerateBillsScreen({super.key});

  @override
  State<GenerateBillsScreen> createState() => _GenerateBillsScreenState();
}

class _GenerateBillsScreenState extends State<GenerateBillsScreen> {
  String _selectedMonth = 'October 2026';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 15));
  final _baseMaintenanceCtrl = TextEditingController(text: '2500');
  final _sinkingFundCtrl = TextEditingController(text: '500');
  final _waterChargesCtrl = TextEditingController(text: '450');

  bool _isGenerating = false;

  @override
  void dispose() {
    _baseMaintenanceCtrl.dispose();
    _sinkingFundCtrl.dispose();
    _waterChargesCtrl.dispose();
    super.dispose();
  }

  int get _totalPerFlat {
    final base = int.tryParse(_baseMaintenanceCtrl.text) ?? 0;
    final sink = int.tryParse(_sinkingFundCtrl.text) ?? 0;
    final water = int.tryParse(_waterChargesCtrl.text) ?? 0;
    return base + sink + water;
  }

  void _generateBatchBills() async {
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => _isGenerating = false);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Bills Generated!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cycle: $_selectedMonth', style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('Flats Billed: 170 units across Towers A, B, C'),
            const SizedBox(height: 4),
            Text('Bill Amount / Flat: ₹$_totalPerFlat'),
            const SizedBox(height: 4),
            Text('Total Billing Value: ₹${((_totalPerFlat * 170) / 100000).toStringAsFixed(2)} Lakhs', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0F5C4D))),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F4F1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Digital invoices published to all resident dashboards with instant payment links.',
                style: TextStyle(fontSize: 12, color: Color(0xFF0F5C4D)),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F5C4D),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            child: const Text('View Collections Ledger'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Generate Monthly Bills', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target Flats Summary Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F5C4D), Color(0xFF167A66)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Batch Bill Generation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                        SizedBox(height: 2),
                        Text('Generates maintenance invoices for all 170 registered society flats.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Billing Period & Due Date
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Billing Cycle & Due Date', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ink)),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedMonth,
                    decoration: InputDecoration(
                      labelText: 'Select Billing Month',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'October 2026', child: Text('October 2026')),
                      DropdownMenuItem(value: 'November 2026', child: Text('November 2026')),
                      DropdownMenuItem(value: 'December 2026', child: Text('December 2026')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedMonth = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _dueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 60)),
                      );
                      if (picked != null) setState(() => _dueDate = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Payment Due Date', style: TextStyle(color: AppColors.mute, fontSize: 11)),
                              Text('${_dueDate.day}/${_dueDate.month}/${_dueDate.year}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                            ],
                          ),
                          const Icon(Icons.event_rounded, color: Color(0xFF0F5C4D)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Charges Breakdown Config
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rate & Charges Breakdown', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ink)),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _baseMaintenanceCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: 'Base Maintenance (₹)',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _sinkingFundCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: 'Sinking & Major Repair Fund (₹)',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _waterChargesCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: 'Water Charges (₹)',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const Divider(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Bill Per Flat:', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ink)),
                      Text(
                        '₹ $_totalPerFlat',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Color(0xFF0F5C4D)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Batch CTA Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5C4D),
                  disabledBackgroundColor: const Color(0xFF0F5C4D),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _isGenerating ? null : _generateBatchBills,
                child: _isGenerating
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                          SizedBox(width: 12),
                          Text('Generating 170 Invoices...', style: TextStyle(fontWeight: FontWeight.w700)),
                        ],
                      )
                    : Text('Generate Bills For 170 Flats (₹${((_totalPerFlat * 170) / 100000).toStringAsFixed(2)} L)', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
