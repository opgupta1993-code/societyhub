import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/role_switcher_chip.dart';

class ManagerHomeScreen extends ConsumerStatefulWidget {
  const ManagerHomeScreen({super.key});

  @override
  ConsumerState<ManagerHomeScreen> createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends ConsumerState<ManagerHomeScreen> {
  int _bottomNavIndex = 0;

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Manager Dashboard Updated'),
          backgroundColor: Color(0xFF0F5C4D),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estate Operations Console',
              style: text.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            Text(
              'Manager Dashboard • ${user?.name ?? "Manager"}',
              style: const TextStyle(fontSize: 11, color: AppColors.mute),
            ),
          ],
        ),
        actions: [
          const RoleSwitcherChip(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.ink),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.ink),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF0F5C4D),
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Manager KPI Cards Row
                Row(
                  children: [
                    Expanded(
                      child: _buildKpiTile('Complaints Queue', '5 Urgent', '2 Unassigned', Colors.red, Icons.assignment_late_rounded),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildKpiTile('Booking Requests', '3 Pending', 'Clubhouse & Lawn', Colors.teal, Icons.event_available_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Primary Operational Grid (Complaint Assign, Approve Booking, Post Notice)
                const Text(
                  'Operations & Tasks',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink),
                ),
                const SizedBox(height: 12),

                _buildManagerActionTile(
                  title: 'Complaints Queue & Dispatch',
                  subtitle: 'Assign plumbing, lift, electrical issues to staff',
                  icon: Icons.build_circle_rounded,
                  color: Colors.red,
                  badgeText: '5 Open',
                  onTap: () => context.push('/complaints'),
                ),
                const SizedBox(height: 12),

                _buildManagerActionTile(
                  title: 'Amenity Booking Approvals',
                  subtitle: 'Review & approve resident clubhouse/gym slots',
                  icon: Icons.check_circle_outline_rounded,
                  color: Colors.teal,
                  badgeText: '3 Pending',
                  onTap: () => context.push('/amenity-booking'),
                ),
                const SizedBox(height: 12),

                _buildManagerActionTile(
                  title: 'Broadcast Society Notice',
                  subtitle: 'Post announcements & emergency alerts to residents',
                  icon: Icons.campaign_rounded,
                  color: Colors.purple,
                  badgeText: 'New',
                  onTap: () => context.push('/notices'),
                ),
                const SizedBox(height: 12),

                _buildManagerActionTile(
                  title: 'View Financial Reports (Read Only)',
                  subtitle: 'Check monthly collection & defaulter lists',
                  icon: Icons.analytics_rounded,
                  color: Colors.deepOrange,
                  badgeText: 'View',
                  onTap: () => context.push('/accountant-reports'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.line.withValues(alpha: 0.6))),
        ),
        child: BottomNavigationBar(
          currentIndex: _bottomNavIndex,
          selectedItemColor: const Color(0xFF0F5C4D),
          unselectedItemColor: AppColors.mute,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() => _bottomNavIndex = index);
            if (index == 1) context.push('/complaints');
            if (index == 2) context.push('/notices');
            if (index == 3) context.push('/profile');
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.build_outlined), label: 'Issues'),
            BottomNavigationBarItem(icon: Icon(Icons.campaign_outlined), label: 'Notices'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiTile(String title, String mainVal, String subVal, Color color, IconData icon) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(mainVal, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.ink)),
          Text(subVal, style: const TextStyle(fontSize: 11, color: AppColors.mute)),
        ],
      ),
    );
  }

  Widget _buildManagerActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String badgeText,
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
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.ink)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.mute)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badgeText,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
