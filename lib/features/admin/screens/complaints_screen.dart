import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class ComplaintItem {
  final String id;
  final String title;
  final String subtitle;
  final String priority; // 'high', 'medium', 'low'
  final bool hasAssignStaffButton;

  const ComplaintItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.priority,
    this.hasAssignStaffButton = false,
  });
}

/// Screen: Complaints (Wireframe Screen for Complaints Overview & Management)
class ComplaintsScreen extends ConsumerStatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  ConsumerState<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends ConsumerState<ComplaintsScreen> {
  final List<ComplaintItem> _complaints = const [
    ComplaintItem(
      id: '1',
      title: 'Lift not working',
      subtitle: 'B-402 · Open 3 days',
      priority: 'high',
      hasAssignStaffButton: true,
    ),
    ComplaintItem(
      id: '2',
      title: 'Water leakage',
      subtitle: 'A-101 · Plumber assigned',
      priority: 'medium',
    ),
    ComplaintItem(
      id: '3',
      title: 'Garbage pickup',
      subtitle: 'C-210 · Resolved today',
      priority: 'low',
    ),
    ComplaintItem(
      id: '4',
      title: 'Intercom connection error',
      subtitle: 'B-104 · Open 1 day',
      priority: 'medium',
    ),
  ];

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complaints list updated'),
          backgroundColor: Color(0xFF0F5C4D),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showAssignStaffModal(ComplaintItem complaint) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Assign Staff for "${complaint.title}"',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select service technician to dispatch for ${complaint.subtitle}.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.mute,
                  ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE6F4F1),
                child: Icon(Icons.build_rounded, color: Color(0xFF0F5C4D)),
              ),
              title: const Text('Ramesh (Main Technician)', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('Lift & Electrical Specialist'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Technician Ramesh assigned to Lift complaint'),
                    backgroundColor: Color(0xFF0F5C4D),
                  ),
                );
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFDF4E7),
                child: Icon(Icons.plumbing_rounded, color: Color(0xFFC27803)),
              ),
              title: const Text('Suresh Plumber', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('Plumbing Specialist'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Technician Suresh assigned'),
                    backgroundColor: Color(0xFF0F5C4D),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F4), // Matching beige tint background from wireframe
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF0F5C4D),
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title: Complaints
                Text(
                  'Complaints',
                  style: text.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 16),

                // Top 2 Grid Metric Cards (New: 5, In progress: 7)
                Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New',
                              style: text.bodyMedium?.copyWith(
                                color: AppColors.mute,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '5',
                              style: text.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: AppCard(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'In progress',
                              style: text.bodyMedium?.copyWith(
                                color: AppColors.mute,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '7',
                              style: text.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Complaints List Cards
                ..._complaints.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildComplaintCard(item),
                    )),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),

      // Bottom Navigation Bar (Home, HR, Billing, Reports, More)
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
          currentIndex: 0, // 'Home' active tab
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
              context.push('/accountant-reports');
            } else if (index == 4) {
              context.go('/admin-roles');
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

  Widget _buildComplaintCard(ComplaintItem item) {
    Color badgeBg;
    Color badgeText;
    String badgeLabel;

    if (item.priority == 'high') {
      badgeBg = const Color(0xFFFEE2E2); // Light red
      badgeText = const Color(0xFFEF4444); // Red
      badgeLabel = 'High';
    } else if (item.priority == 'medium') {
      badgeBg = const Color(0xFFFDF4E7); // Light peach/amber
      badgeText = const Color(0xFFC27803); // Orange
      badgeLabel = 'Medium';
    } else {
      badgeBg = const Color(0xFFE6F4F1); // Light mint
      badgeText = const Color(0xFF0F5C4D); // Green
      badgeLabel = 'Low';
    }

    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeLabel,
                  style: TextStyle(
                    color: badgeText,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            item.subtitle,
            style: const TextStyle(
              color: AppColors.mute,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (item.hasAssignStaffButton) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5C4D),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () => _showAssignStaffModal(item),
                child: const Text('Assign staff'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
