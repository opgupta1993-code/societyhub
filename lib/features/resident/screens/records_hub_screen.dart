import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

/// Screen C1: My Records Hub
/// PRD: Rent, charges, payments, issues, summary
class RecordsHubScreen extends StatefulWidget {
  const RecordsHubScreen({super.key});

  @override
  State<RecordsHubScreen> createState() => _RecordsHubScreenState();
}

class _RecordsHubScreenState extends State<RecordsHubScreen> {
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Records Hub refreshed'),
          backgroundColor: Color(0xFF0F5C4D),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showExportDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Export Statement (C7)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Download combined rent, dues, and transaction records',
                style: TextStyle(fontSize: 13, color: AppColors.mute),
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 24),
                ),
                title: const Text('Download PDF Statement', style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('Official stamped ledger with society seal', style: TextStyle(fontSize: 12)),
                trailing: const Icon(Icons.download_rounded, color: AppColors.primary),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Downloading SocietyHub_Statement_FY26.pdf...'),
                      backgroundColor: Color(0xFF0F5C4D),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.table_chart_rounded, color: Colors.green, size: 24),
                ),
                title: const Text('Export Excel (.xlsx)', style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('Itemized spreadsheet for tax filing & audit', style: TextStyle(fontSize: 12)),
                trailing: const Icon(Icons.download_rounded, color: AppColors.primary),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Downloading SocietyHub_Records_2026.xlsx...'),
                      backgroundColor: Color(0xFF0F5C4D),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F4),
      appBar: AppBar(
        title: const Text(
          'My Records Hub (C1)',
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
            tooltip: 'Export Statement',
            icon: const Icon(Icons.file_download_outlined, color: AppColors.ink),
            onPressed: _showExportDialog,
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF0F5C4D),
        onRefresh: _handleRefresh,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Master Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F5C4D), Color(0xFF167A66)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F5C4D).withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Unit: Tower B - 402',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0062E0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Active Tenancy',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Total Dues Pending',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: const [
                      Text(
                        '₹21,450',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '(Rent ₹18k + Dues ₹3.4k)',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0F5C4D),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => context.push('/rent'),
                          child: const Text('Pay Rent (C2)', style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0062E0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => context.push('/charges-breakup'),
                          child: const Text('Breakup (C4)', style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Hub Navigation Cards
            const Text(
              'Records & Modules',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink),
            ),
            const SizedBox(height: 12),

            _buildHubTile(
              title: 'Charges & Dues Breakup (C4)',
              subtitle: 'Maintenance, water, parking, and sinking fund line items',
              icon: Icons.pie_chart_outline_rounded,
              color: Colors.teal,
              badge: '₹3,450 Due',
              onTap: () => context.push('/charges-breakup'),
            ),
            const SizedBox(height: 10),

            _buildHubTile(
              title: 'Rent & Agreement Ledger (C2/C3)',
              subtitle: 'Monthly rent status, receipts & landlord agreements',
              icon: Icons.currency_rupee_rounded,
              color: Colors.indigo,
              badge: 'Due 5 Nov',
              onTap: () => context.push('/rent'),
            ),
            const SizedBox(height: 10),

            _buildHubTile(
              title: 'Issues & Tickets Timeline (C6)',
              subtitle: '1 active ticket under resolution by maintenance team',
              icon: Icons.build_circle_outlined,
              color: Colors.orange,
              badge: '1 Open',
              onTap: () => context.push('/complaints'),
            ),
            const SizedBox(height: 10),

            _buildHubTile(
              title: 'Landlord Shared Access (C9/C10)',
              subtitle: 'Invite owner or family with custom view permissions',
              icon: Icons.share_rounded,
              color: const Color(0xFF0062E0),
              badge: 'Active Link',
              onTap: () => context.push('/shared-access'),
            ),
            const SizedBox(height: 24),

            // Recent Payment Activity (C5)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payment History (C5)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink),
                ),
                TextButton.icon(
                  onPressed: _showExportDialog,
                  icon: const Icon(Icons.file_download_outlined, size: 16),
                  label: const Text('Export', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            _buildHistoryItem(
              title: 'September 2026 Rent',
              date: '04 Sep 2026 · UPI Ref #98129',
              amount: '₹18,000',
              status: 'PAID',
              isSuccess: true,
            ),
            const SizedBox(height: 8),
            _buildHistoryItem(
              title: 'Society Maintenance (Q3)',
              date: '02 Sep 2026 · Card **** 4109',
              amount: '₹3,450',
              status: 'PAID',
              isSuccess: true,
            ),
            const SizedBox(height: 8),
            _buildHistoryItem(
              title: 'August 2026 Rent',
              date: '05 Aug 2026 · Netbanking HDFC',
              amount: '₹18,000',
              status: 'PAID',
              isSuccess: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHubTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String badge,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
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
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: AppColors.mute),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge,
                style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem({
    required String title,
    required String date,
    required String amount,
    required String status,
    required bool isSuccess,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSuccess ? const Color(0xFFE6F4F1) : Colors.amber.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSuccess ? Icons.check_circle_outline_rounded : Icons.schedule_rounded,
              color: isSuccess ? const Color(0xFF0F5C4D) : Colors.amber.shade800,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.ink)),
                const SizedBox(height: 2),
                Text(date, style: const TextStyle(fontSize: 11, color: AppColors.mute)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.ink)),
              const SizedBox(height: 2),
              Text(
                status,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: isSuccess ? const Color(0xFF0F5C4D) : Colors.amber.shade900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
