import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class ExpenseRecord {
  final String id;
  final String title;
  final String category;
  final String vendor;
  final int amount;
  final String date;
  final String paymentMode;

  ExpenseRecord({
    required this.id,
    required this.title,
    required this.category,
    required this.vendor,
    required this.amount,
    required this.date,
    required this.paymentMode,
  });
}

/// Module 3: Accounts & Billing - Society Expense Tracker & Bill Logging
class LogExpenseScreen extends StatefulWidget {
  const LogExpenseScreen({super.key});

  @override
  State<LogExpenseScreen> createState() => _LogExpenseScreenState();
}

class _LogExpenseScreenState extends State<LogExpenseScreen> {
  final List<ExpenseRecord> _expenses = [
    ExpenseRecord(
      id: 'EXP-801',
      title: 'Diesel for Backup DG Generator (200 Litres)',
      category: 'Utilities',
      vendor: 'Bharat Petroleum Kothrud',
      amount: 18800,
      date: '10 Oct 2026',
      paymentMode: 'NEFT',
    ),
    ExpenseRecord(
      id: 'EXP-802',
      title: 'Lift AMC Quarterly Servicing (Towers A & B)',
      category: 'Repairs & Maintenance',
      vendor: 'Schindler Elevators Pvt Ltd',
      amount: 24500,
      date: '08 Oct 2026',
      paymentMode: 'Cheque #44102',
    ),
    ExpenseRecord(
      id: 'EXP-803',
      title: 'Security Guard Agency Monthly Payout (4 Guards)',
      category: 'Security Staff',
      vendor: 'Eagle Eye Security Services',
      amount: 48000,
      date: '05 Oct 2026',
      paymentMode: 'RTGS',
    ),
    ExpenseRecord(
      id: 'EXP-804',
      title: 'Borewell Pump Repair & Capacitor Replacement',
      category: 'Repairs & Maintenance',
      vendor: 'Ganesh Electricals',
      amount: 4200,
      date: '02 Oct 2026',
      paymentMode: 'UPI',
    ),
  ];

  void _showAddExpenseModal() {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final vendorCtrl = TextEditingController();
    String category = 'Repairs & Maintenance';
    String mode = 'NEFT/RTGS';
    bool billAttached = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Log New Society Expense', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink)),
                      IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleCtrl,
                    decoration: InputDecoration(
                      labelText: 'Expense Description',
                      hintText: 'e.g. Swimming Pool Chemical Kit',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: amountCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Amount (₹)',
                            prefixText: '₹ ',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: category,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Repairs & Maintenance', child: Text('Repairs', style: TextStyle(fontSize: 13))),
                            DropdownMenuItem(value: 'Utilities', child: Text('Utilities', style: TextStyle(fontSize: 13))),
                            DropdownMenuItem(value: 'Security Staff', child: Text('Security', style: TextStyle(fontSize: 13))),
                            DropdownMenuItem(value: 'Housekeeping', child: Text('Cleaning', style: TextStyle(fontSize: 13))),
                          ],
                          onChanged: (val) {
                            if (val != null) setSheetState(() => category = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: vendorCtrl,
                    decoration: InputDecoration(
                      labelText: 'Paid To / Vendor Name',
                      hintText: 'e.g. Apex Electricals',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: mode,
                    decoration: InputDecoration(
                      labelText: 'Payment Mode',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'NEFT/RTGS', child: Text('NEFT / Bank Transfer')),
                      DropdownMenuItem(value: 'Cheque', child: Text('Cheque')),
                      DropdownMenuItem(value: 'UPI', child: Text('UPI / QR')),
                      DropdownMenuItem(value: 'Cash', child: Text('Petty Cash')),
                    ],
                    onChanged: (val) {
                      if (val != null) setSheetState(() => mode = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => setSheetState(() => billAttached = !billAttached),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: billAttached ? Colors.green : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(14),
                        color: billAttached ? Colors.green.withValues(alpha: 0.08) : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(billAttached ? Icons.check_circle_rounded : Icons.camera_alt_outlined, color: billAttached ? Colors.green : AppColors.mute),
                              const SizedBox(width: 10),
                              Text(billAttached ? 'Bill Proof Attached (invoice.jpg)' : 'Attach Vendor Invoice / Receipt', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: billAttached ? Colors.green : AppColors.mute)),
                            ],
                          ),
                          Text(billAttached ? 'Change' : 'Upload', style: const TextStyle(color: Color(0xFF0F5C4D), fontWeight: FontWeight.w700, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F5C4D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        final amt = int.tryParse(amountCtrl.text.trim()) ?? 0;
                        if (titleCtrl.text.trim().isNotEmpty && amt > 0) {
                          setState(() {
                            _expenses.insert(
                              0,
                              ExpenseRecord(
                                id: 'EXP-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                                title: titleCtrl.text.trim(),
                                category: category,
                                vendor: vendorCtrl.text.trim().isEmpty ? 'General Vendor' : vendorCtrl.text.trim(),
                                amount: amt,
                                date: 'Today',
                                paymentMode: mode,
                              ),
                            );
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Expense logged and recorded in society accounts!'),
                              backgroundColor: Color(0xFF0F5C4D),
                            ),
                          );
                        }
                      },
                      child: const Text('Save Expense Entry', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalSpent = _expenses.fold<int>(0, (sum, e) => sum + e.amount);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Log Society Expenses', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF0F5C4D)),
            onPressed: _showAddExpenseModal,
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF0F5C4D),
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 600));
          if (mounted) setState(() {});
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            // Expense Overview KPI Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF881337), Color(0xFFBE123C)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.red.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Month Expenses (October)', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  Text('₹ ${(totalSpent / 1000).toStringAsFixed(1)} K', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_expenses.length} Entries Recorded', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                      TextButton.icon(
                        style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.white24),
                        onPressed: _showAddExpenseModal,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Log Expense', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Recent Society Expenses', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.ink)),
            const SizedBox(height: 12),

            ..._expenses.map((e) => _buildExpenseCard(e)),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseCard(ExpenseRecord e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(e.category, style: const TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
                Text(e.date, style: const TextStyle(color: AppColors.mute, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 10),
            Text(e.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.ink)),
            const SizedBox(height: 4),
            Text('Vendor: ${e.vendor} • Via ${e.paymentMode}', style: const TextStyle(color: AppColors.mute, fontSize: 12)),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e.id, style: const TextStyle(color: AppColors.mute, fontSize: 11)),
                Text('₹ ${e.amount}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFFBE123C))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
