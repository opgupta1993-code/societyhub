import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/language_selection_modal.dart';
import '../../../shared/widgets/logout_dialog.dart';
import '../../../shared/widgets/role_switcher_chip.dart';

/// Screen: Manager Home Dashboard (Matches SocietyHub wireframe design language)
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
          backgroundColor: AppColors.primary,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showManagerMoreMenu(BuildContext context) {
    final user = ref.read(authProvider).user;
    final societyName = user?.societyName ?? 'Demo Housing Society';
    final userName = user?.name ?? 'Estate Manager';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          'Estate Manager · $societyName',
                          style: const TextStyle(fontSize: 12, color: AppColors.mute),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: AppColors.line),
                const SizedBox(height: 8),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.tint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.translate_rounded, color: AppColors.primary, size: 22),
                  ),
                  title: const Text('Change Language / भाषा', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: const Text('English, हिन्दी, தமிழ், తెలుగు...', style: TextStyle(fontSize: 12, color: AppColors.mute)),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.mute),
                  onTap: () {
                    Navigator.pop(ctx);
                    showLanguageSelectionSheet(context, ref);
                  },
                ),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person_outline_rounded, color: Colors.blue, size: 22),
                  ),
                  title: const Text('My Profile & Account', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: const Text('Manage your phone, email & emergency contacts', style: TextStyle(fontSize: 12, color: AppColors.mute)),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.mute),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/profile');
                  },
                ),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.security_rounded, color: Colors.teal, size: 22),
                  ),
                  title: const Text('Security Staff & Gate Log', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: const Text('View guard roster and on-duty staff', style: TextStyle(fontSize: 12, color: AppColors.mute)),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.mute),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/guard-staff');
                  },
                ),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.help_outline_rounded, color: Colors.purple, size: 22),
                  ),
                  title: const Text('Help & Support', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: const Text('FAQs, technical issues & society guidelines', style: TextStyle(fontSize: 12, color: AppColors.mute)),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.mute),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/help-support');
                  },
                ),

                const Divider(height: 16, color: AppColors.line),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.logout_rounded, color: Colors.red, size: 22),
                  ),
                  title: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.red)),
                  subtitle: const Text('Sign out of your manager account', style: TextStyle(fontSize: 12, color: AppColors.mute)),
                  onTap: () {
                    Navigator.pop(ctx);
                    showLogoutConfirmationDialog(context, ref);
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final user = ref.watch(authProvider).user;
    final societyName = user?.societyName ?? 'Demo Housing Society';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row (Matches Wireframe Header)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          societyName,
                          style: text.bodyMedium?.copyWith(
                            color: AppColors.mute,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Estate Manager',
                          style: text.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        const RoleSwitcherChip(),
                        const SizedBox(width: 8),
                        // Amber Notification Bell Badge
                        GestureDetector(
                          onTap: () => context.push('/notifications'),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFEF3C7), // Light amber/gold container
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_rounded,
                              color: Color(0xFFD97706), // Gold bell icon
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Three Dots More Menu (•••)
                        GestureDetector(
                          onTap: () => _showManagerMoreMenu(context),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.more_horiz_rounded,
                              color: AppColors.ink,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Hero Card: Operations Overview (Dark Teal Rounded Box)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Operations overview · Today',
                            style: text.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '92% on time',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '5 Open Issues',
                        style: text.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 34,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Progress Bar (Resolved vs Total)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: 0.72,
                          minHeight: 7,
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '2 Urgent · 13 Resolved this week',
                            style: text.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          InkWell(
                            onTap: () => context.push('/manager-complaints'),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Dispatch',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2x2 Grid Metric Cards
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.push('/manager-complaints'),
                        child: AppCard(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Open complaints',
                                style: text.bodyMedium?.copyWith(
                                  color: AppColors.mute,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '5',
                                    style: text.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.ink,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEE2E2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      '2 Urgent',
                                      style: TextStyle(
                                        color: Color(0xFFEF4444),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.push('/manager-approvals'),
                        child: AppCard(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pending bookings',
                                style: text.bodyMedium?.copyWith(
                                  color: AppColors.mute,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '3',
                                    style: text.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.ink,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.tint,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'Clubhouse',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.push('/guard-staff'),
                        child: AppCard(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Staff on duty',
                                style: text.bodyMedium?.copyWith(
                                  color: AppColors.mute,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '8',
                                style: text.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.push('/notices'),
                        child: AppCard(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Active notices',
                                style: text.bodyMedium?.copyWith(
                                  color: AppColors.mute,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '4',
                                style: text.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Needs Attention Card (Wireframe Style)
                GestureDetector(
                  onTap: () => context.push('/manager-complaints'),
                  child: AppCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Needs attention',
                              style: text.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                                fontSize: 20,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Text(
                                '3',
                                style: TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Lift #2 Tower B urgent repair · 2 unassigned complaints',
                          style: text.bodyMedium?.copyWith(
                            color: AppColors.mute,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Primary Operational Grid Title
                const Text(
                  'Operations & Tasks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 14),

                // Operations Action Cards
                _buildManagerActionTile(
                  title: 'Complaints Queue & Dispatch',
                  subtitle: 'Assign plumbing, lift, electrical issues to staff',
                  icon: Icons.build_circle_rounded,
                  color: const Color(0xFFEF4444),
                  badgeText: '5 Open',
                  onTap: () => context.push('/manager-complaints'),
                ),
                const SizedBox(height: 12),

                _buildManagerActionTile(
                  title: 'Amenity Booking Approvals',
                  subtitle: 'Review & approve resident clubhouse/gym slots',
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.primary,
                  badgeText: '3 Pending',
                  onTap: () => context.push('/manager-approvals'),
                ),
                const SizedBox(height: 12),

                _buildManagerActionTile(
                  title: 'Broadcast Society Notice',
                  subtitle: 'Post announcements & emergency alerts to residents',
                  icon: Icons.campaign_rounded,
                  color: Colors.purple,
                  badgeText: 'New',
                  onTap: () => context.push('/manager-create-notice'),
                ),
                const SizedBox(height: 12),

                _buildManagerActionTile(
                  title: 'Gate & Visitor Management',
                  subtitle: 'Monitor real-time guard visitor entry and delivery',
                  icon: Icons.shield_outlined,
                  color: Colors.blue,
                  badgeText: 'Live',
                  onTap: () => context.push('/visitor-log'),
                ),
                const SizedBox(height: 12),

                _buildManagerActionTile(
                  title: 'Financial Reports (Read Only)',
                  subtitle: 'Check monthly collection & defaulter lists',
                  icon: Icons.analytics_rounded,
                  color: Colors.deepOrange,
                  badgeText: 'View',
                  onTap: () => context.push('/accountant-reports'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),

      // Bottom Navigation Bar (5 Items: Home, Issues, Bookings, Notices, More)
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
          currentIndex: _bottomNavIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.mute,
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
          onTap: (index) {
            if (index == 0) {
              setState(() => _bottomNavIndex = 0);
            } else if (index == 1) {
              context.push('/manager-complaints');
            } else if (index == 2) {
              context.push('/manager-approvals');
            } else if (index == 3) {
              context.push('/manager-create-notice');
            } else if (index == 4) {
              _showManagerMoreMenu(context);
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build_outlined),
              activeIcon: Icon(Icons.build_rounded),
              label: 'Issues',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_available_outlined),
              activeIcon: Icon(Icons.event_available_rounded),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.campaign_outlined),
              activeIcon: Icon(Icons.campaign_rounded),
              label: 'Notices',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz_rounded),
              activeIcon: Icon(Icons.more_horiz_rounded),
              label: 'More',
            ),
          ],
        ),
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
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mute,
                    ),
                  ),
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
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppColors.mute, size: 20),
          ],
        ),
      ),
    );
  }
}
