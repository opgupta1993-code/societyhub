import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class ReportCardItem {
  final String title;
  final String description;
  final IconData icon;

  const ReportCardItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

/// Screen: Financial Reports (High Fidelity Reports Screen for Admin & Accountant)
class FinancialReportsScreen extends ConsumerStatefulWidget {
  const FinancialReportsScreen({super.key});

  @override
  ConsumerState<FinancialReportsScreen> createState() => _FinancialReportsScreenState();
}

class _FinancialReportsScreenState extends ConsumerState<FinancialReportsScreen> {
  final List<ReportCardItem> _reports = const [
    ReportCardItem(
      title: 'Monthly Collection Summary',
      description: 'Overview of paid, pending & overdue maintenance dues for Oct 2026',
      icon: Icons.pie_chart_outline_rounded,
    ),
    ReportCardItem(
      title: 'Defaulters List & Dues Report',
      description: 'Flat-wise break-up of defaulters with total outstanding amounts',
      icon: Icons.warning_amber_rounded,
    ),
    ReportCardItem(
      title: 'Society Expense Ledger',
      description: 'Categorized operational & maintenance expenditure report with receipt links',
      icon: Icons.receipt_long_rounded,
    ),
    ReportCardItem(
      title: 'Annual Balance Sheet',
      description: 'Audited yearly financial summary statement for society meetings',
      icon: Icons.account_balance_outlined,
    ),
  ];

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Financial reports updated'),
          backgroundColor: Color(0xFF0F5C4D),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _downloadReport(String format, String reportTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading "$reportTitle" in $format format...'),
        backgroundColor: const Color(0xFF0F5C4D),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F4), // Matching beige tint background from wireframe
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Screen Title (Financial Reports)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  Text(
                    'Financial Reports',
                    style: text.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Reports List with Pull-to-Refresh
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF0F5C4D),
                onRefresh: _handleRefresh,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  itemCount: _reports.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = _reports[index];
                    return _buildReportCard(item);
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar (Home, HR, Billing, Reports, More) with 'Reports' active
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: AppColors.line.withValues(alpha: 0.6),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: 3, // 'Reports' active tab
          selectedItemColor: const Color(0xFF0F5C4D),
          unselectedItemColor: AppColors.mute,
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
          onTap: (index) {
            if (index == 0) {
              context.go('/home');
            } else if (index == 1) {
              context.go('/admin-hr');
            } else if (index == 2) {
              context.push('/accountant-collections');
            } else if (index == 3) {
              // Already on Reports tab
            } else if (index == 4) {
              context.go('/admin-settings');
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sentiment_satisfied_alt_outlined),
              activeIcon: Icon(Icons.sentiment_satisfied_alt_rounded),
              label: 'HR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_rupee_rounded),
              activeIcon: Icon(Icons.currency_rupee_rounded),
              label: 'Billing',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              activeIcon: Icon(Icons.article_rounded),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings_rounded),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(ReportCardItem item) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F4F1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: const Color(0xFF0F5C4D), size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.description,
            style: const TextStyle(
              color: AppColors.mute,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0F5C4D),
                    side: const BorderSide(color: Color(0xFF0F5C4D), width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () => _downloadReport('PDF', item.title),
                  icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                  label: const Text('PDF Report', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F5C4D),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () => _downloadReport('Excel', item.title),
                  icon: const Icon(Icons.table_chart_rounded, size: 18),
                  label: const Text('Excel Sheet', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
