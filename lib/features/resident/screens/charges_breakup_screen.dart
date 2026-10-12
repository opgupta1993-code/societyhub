import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

/// Screen C4: Charges Breakup
/// PRD: Maintenance, water, parking, late fee
class ChargesBreakupScreen extends StatefulWidget {
  const ChargesBreakupScreen({super.key});

  @override
  State<ChargesBreakupScreen> createState() => _ChargesBreakupScreenState();
}

class _ChargesBreakupScreenState extends State<ChargesBreakupScreen> {
  String _selectedMonth = 'October 2026';

  final List<String> _months = const [
    'October 2026',
    'September 2026',
    'August 2026',
  ];

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Charges Breakup updated'),
          backgroundColor: Color(0xFF0F5C4D),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F4),
      appBar: AppBar(
        title: const Text(
          'Charges Breakup (C4)',
          style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            tooltip: 'Download Bill',
            icon: const Icon(Icons.download_rounded, color: AppColors.ink),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Downloading Maintenance_Bill_Oct2026.pdf...'),
                  backgroundColor: Color(0xFF0F5C4D),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF0F5C4D),
        onRefresh: _handleRefresh,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Month Selector Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Billing Cycle',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedMonth,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                      items: _months.map((m) {
                        return DropdownMenuItem(
                          value: m,
                          child: Text(
                            m,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.ink),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedMonth = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Total Amount Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F5C4D), Color(0xFF167A66)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F5C4D).withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Monthly Society Dues',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'UNPAID',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '₹3,450.00',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Icon(Icons.event_outlined, color: Colors.white70, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Due by 15 Oct 2026 · Flat B-402 (1,200 sq.ft)',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Detailed Itemized List
            const Text(
              'Itemized Line Charges',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink),
            ),
            const SizedBox(height: 12),

            _buildChargeItem(
              title: 'Society Maintenance',
              formula: '1,200 sq.ft × ₹2.00 / sq.ft',
              amount: '₹2,400.00',
              icon: Icons.apartment_rounded,
              color: const Color(0xFF0F5C4D),
            ),
            const SizedBox(height: 10),

            _buildChargeItem(
              title: 'Water & Sewerage Charges',
              formula: 'Fixed quota + 4,500 L consumed',
              amount: '₹450.00',
              icon: Icons.water_drop_outlined,
              color: Colors.blue,
            ),
            const SizedBox(height: 10),

            _buildChargeItem(
              title: 'Reserved Parking Slot',
              formula: 'Covered basement slot P-24',
              amount: '₹500.00',
              icon: Icons.directions_car_outlined,
              color: Colors.orange,
            ),
            const SizedBox(height: 10),

            _buildChargeItem(
              title: 'Sinking & Repair Reserve Fund',
              formula: 'Mandatory society reserve',
              amount: '₹100.00',
              icon: Icons.account_balance_outlined,
              color: Colors.purple,
            ),
            const SizedBox(height: 10),

            _buildChargeItem(
              title: 'Late Payment Fee / Penalty',
              formula: '0% before 15 Oct · ₹100 post due date',
              amount: '₹0.00',
              icon: Icons.speed_rounded,
              color: Colors.green,
              isZero: true,
            ),
            const SizedBox(height: 20),

            // Notes Card
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Payment Rules & Grace Period',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.ink),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Invoices are generated on the 1st of every month. Payments made after 15th will incur a late fine of ₹100 per week as per AGM resolution 2025.',
                          style: TextStyle(fontSize: 11.5, color: AppColors.mute, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Pay Now CTA Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5C4D),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                onPressed: () => context.push('/dues'),
                icon: const Icon(Icons.payment_rounded, size: 20),
                label: const Text(
                  'Pay ₹3,450 Now (UPI / Card / Netbanking)',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Center(
              child: TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Downloading detailed Tax Invoice PDF...'),
                      backgroundColor: Color(0xFF0F5C4D),
                    ),
                  );
                },
                icon: const Icon(Icons.receipt_long_rounded, size: 16),
                label: const Text(
                  'Download Itemized Tax Invoice',
                  style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChargeItem({
    required String title,
    required String formula,
    required String amount,
    required IconData icon,
    required Color color,
    bool isZero = false,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.ink),
                ),
                const SizedBox(height: 2),
                Text(
                  formula,
                  style: const TextStyle(fontSize: 12, color: AppColors.mute),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: isZero ? Colors.green.shade700 : AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
