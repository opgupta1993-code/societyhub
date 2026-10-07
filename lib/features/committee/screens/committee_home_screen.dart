import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/app_card.dart';

class CommitteeHomeScreen extends ConsumerStatefulWidget {
  const CommitteeHomeScreen({super.key});

  @override
  ConsumerState<CommitteeHomeScreen> createState() => _CommitteeHomeScreenState();
}

class _CommitteeHomeScreenState extends ConsumerState<CommitteeHomeScreen> {
  int _bottomNavIndex = 0;

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Committee Executive Dashboard Updated'),
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
              'Managing Committee Desk',
              style: text.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            Text(
              'Committee Executive • ${user?.name ?? "Committee Member"}',
              style: const TextStyle(fontSize: 11, color: AppColors.mute),
            ),
          ],
        ),
        actions: [
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
                // Committee KPI Cards Row
                Row(
                  children: [
                    Expanded(
                      child: _buildKpiTile('Active Poll', 'EV Charging', '84 Votes Cast', Colors.pink, Icons.poll_rounded),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildKpiTile('Next Meeting', 'AGM 2026', '15th Oct 5 PM', Colors.brown, Icons.groups_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Committee Governance Modules
                const Text(
                  'Governance & Meetings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink),
                ),
                const SizedBox(height: 12),

                _buildCommitteeTile(
                  title: 'Create & Manage Polls',
                  subtitle: 'Publish resolution voting for society members',
                  icon: Icons.how_to_vote_rounded,
                  color: Colors.pink,
                  onTap: () => context.push('/polls'),
                ),
                const SizedBox(height: 12),

                _buildCommitteeTile(
                  title: 'AGM Meetings & MoM Minutes',
                  subtitle: 'Schedule meetings, publish agenda & recorded minutes',
                  icon: Icons.groups_rounded,
                  color: Colors.brown,
                  onTap: () => context.push('/notices'),
                ),
                const SizedBox(height: 12),

                _buildCommitteeTile(
                  title: 'Broadcast Committee Notice',
                  subtitle: 'Post official committee circulars to residents',
                  icon: Icons.campaign_rounded,
                  color: Colors.purple,
                  onTap: () => context.push('/notices'),
                ),
                const SizedBox(height: 12),

                _buildCommitteeTile(
                  title: 'Executive Financial Summary',
                  subtitle: 'Review collection reports, audit ledger & expenses',
                  icon: Icons.article_rounded,
                  color: const Color(0xFF0F5C4D),
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
            if (index == 1) context.push('/polls');
            if (index == 2) context.push('/accountant-reports');
            if (index == 3) context.push('/profile');
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.poll_outlined), label: 'Polls'),
            BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Reports'),
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
          Text(mainVal, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.ink)),
          Text(subVal, style: const TextStyle(fontSize: 11, color: AppColors.mute)),
        ],
      ),
    );
  }

  Widget _buildCommitteeTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
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
            const Icon(Icons.chevron_right_rounded, color: AppColors.mute),
          ],
        ),
      ),
    );
  }
}
