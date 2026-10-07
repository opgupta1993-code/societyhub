import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/language_selection_modal.dart';
import '../../../shared/widgets/logout_dialog.dart';

class SettingsOptionItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const SettingsOptionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.iconColor,
  });
}

/// Screen: Society Settings & More (High Fidelity Settings & More Hub for Admin)
class SocietySettingsScreen extends ConsumerStatefulWidget {
  const SocietySettingsScreen({super.key});

  @override
  ConsumerState<SocietySettingsScreen> createState() => _SocietySettingsScreenState();
}

class _SocietySettingsScreenState extends ConsumerState<SocietySettingsScreen> {
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings updated'),
          backgroundColor: Color(0xFF0F5C4D),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    final List<SettingsOptionItem> optionsList = [
      SettingsOptionItem(
        title: 'Roles & Permissions',
        subtitle: 'Edit access control & permission toggles for staff roles',
        icon: Icons.admin_panel_settings_outlined,
        onTap: () => context.push('/admin-roles'),
      ),
      SettingsOptionItem(
        title: 'Audit Log',
        subtitle: 'View complete administrative activity & system modification history',
        icon: Icons.history_rounded,
        onTap: () => context.push('/admin-audit'),
      ),
      SettingsOptionItem(
        title: 'Society Profile & Maintenance Rates',
        subtitle: 'Update society address, flat counts, rates & late fee rules',
        icon: Icons.storefront_outlined,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Society profile & rate rules saved'),
              backgroundColor: Color(0xFF0F5C4D),
            ),
          );
        },
      ),
      SettingsOptionItem(
        title: 'Language / भाषा चुनें',
        subtitle: 'Switch application language (English, Hindi, Marathi, Gujarati)',
        icon: Icons.language_rounded,
        onTap: () => showLanguageSelectionSheet(context, ref),
      ),
      SettingsOptionItem(
        title: 'Logout from Account',
        subtitle: 'Sign out safely from SocietyHub',
        icon: Icons.logout_rounded,
        iconColor: AppColors.red,
        onTap: () => showLogoutConfirmationDialog(context, ref),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F4), // Matching beige tint background from wireframe
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Screen Title (Society Settings & More)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  Text(
                    'More · Settings',
                    style: text.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Options List with Pull-to-Refresh
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF0F5C4D),
                onRefresh: _handleRefresh,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  itemCount: optionsList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = optionsList[index];
                    return _buildOptionCard(item);
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
              // Already on More tab
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

  Widget _buildOptionCard(SettingsOptionItem item) {
    final color = item.iconColor ?? const Color(0xFF0F5C4D);
    final isLogout = item.iconColor == AppColors.red;

    return GestureDetector(
      onTap: item.onTap,
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isLogout ? const Color(0xFFFEE2E2) : const Color(0xFFE6F4F1),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: isLogout ? AppColors.red : AppColors.ink,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      color: AppColors.mute,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.mute.withValues(alpha: 0.6),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
