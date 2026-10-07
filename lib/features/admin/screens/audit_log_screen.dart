import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class AuditLogItem {
  final String id;
  final String title;
  final String description;
  final String timestamp;
  final String category; // 'roles', 'payments'

  const AuditLogItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.category,
  });
}

/// Screen: Audit Log (Wireframe Screen for Admin Activity & Audit Trails)
class AuditLogScreen extends ConsumerStatefulWidget {
  const AuditLogScreen({super.key});

  @override
  ConsumerState<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends ConsumerState<AuditLogScreen> {
  String _selectedTab = 'All'; // 'All', 'Roles', 'Payments'

  final List<AuditLogItem> _logs = const [
    AuditLogItem(
      id: '1',
      title: 'Role changed',
      description: 'Admin made Anita M. a Manager',
      timestamp: 'Today · 10:42 AM',
      category: 'roles',
    ),
    AuditLogItem(
      id: '2',
      title: 'Role removed',
      description: 'Admin removed Guard role from Ramesh',
      timestamp: 'Yesterday · 6:10 PM',
      category: 'roles',
    ),
    AuditLogItem(
      id: '3',
      title: 'User removed',
      description: 'Admin removed Vikas K. from society',
      timestamp: '3 Oct · 2:30 PM',
      category: 'roles',
    ),
    AuditLogItem(
      id: '4',
      title: 'Bills generated',
      description: 'Accountant · Oct 2026 · 240 flats',
      timestamp: '1 Oct · 9:00 AM',
      category: 'payments',
    ),
    AuditLogItem(
      id: '5',
      title: 'Maintenance paid',
      description: 'Rahul S. (B-402) paid ₹3,450 via UPI',
      timestamp: '1 Oct · 8:15 AM',
      category: 'payments',
    ),
  ];

  List<AuditLogItem> get _filteredLogs {
    if (_selectedTab == 'Roles') {
      return _logs.where((l) => l.category == 'roles').toList();
    } else if (_selectedTab == 'Payments') {
      return _logs.where((l) => l.category == 'payments').toList();
    }
    return _logs;
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Audit log refreshed'),
          backgroundColor: Color(0xFF0F5C4D),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F4), // Matching beige tint background from wireframe
      body: SafeArea(
        child: Column(
          children: [
            // Header Title: Audit log
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  Text(
                    'Audit log',
                    style: text.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),

            // Segment Filter Tabs (All, Roles, Payments)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _filterTabPill('All'),
                  const SizedBox(width: 10),
                  _filterTabPill('Roles'),
                  const SizedBox(width: 10),
                  _filterTabPill('Payments'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Audit Logs List with Pull-to-Refresh
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF0F5C4D),
                onRefresh: _handleRefresh,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  itemCount: _filteredLogs.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _filteredLogs[index];
                    return _buildAuditCard(item);
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar (Home, HR, Billing, Reports, More) with 'More' active
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
          currentIndex: 4, // 'More' active tab
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

  Widget _filterTabPill(String title) {
    final isActive = _selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedTab = title);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0F5C4D) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF0F5C4D).withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF475569),
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildAuditCard(AuditLogItem item) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.description,
            style: const TextStyle(
              color: AppColors.mute,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.timestamp,
            style: const TextStyle(
              color: AppColors.mute,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
