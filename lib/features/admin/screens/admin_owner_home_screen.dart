import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/language_selection_modal.dart';
import '../../../shared/widgets/logout_dialog.dart';
import '../../../shared/widgets/role_switcher_chip.dart';

/// Screen: Admin / Owner Home Dashboard (matches wireframe image 2 exactly)
class AdminOwnerHomeScreen extends ConsumerStatefulWidget {
  const AdminOwnerHomeScreen({super.key});

  @override
  ConsumerState<AdminOwnerHomeScreen> createState() => _AdminOwnerHomeScreenState();
}

class _AdminOwnerHomeScreenState extends ConsumerState<AdminOwnerHomeScreen> {
  int _bottomNavIndex = 0; // Home tab selected

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final societyName = user?.societyName ?? 'Demo Housing Society';
    final roleTitle = user?.isOwner == true ? 'Owner / Admin' : 'Admin';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF0F5C4D),
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 800));
            if (mounted) setState(() {});
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header Row
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
                        roleTitle,
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
                      // Language Switcher Globe Button
                      GestureDetector(
                        onTap: () => showLanguageSelectionSheet(context, ref),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.language_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Logout Button (Light Red background)
                      GestureDetector(
                        onTap: () => showLogoutConfirmationDialog(context, ref),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFEE2E2), // Light red container
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            color: Color(0xFFEF4444), // Red logout icon
                            size: 20,
                          ),
                        ),
                      ),
                      // Notification Bell Badge (Light Amber background)
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
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Hero Card: Collected this month (85% of ₹9.6L target)
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
                    Text(
                      'Collected this month',
                      style: text.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '₹8.2L',
                      style: text.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: 0.85,
                        minHeight: 7,
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      '85% of ₹9.6L target',
                      style: text.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2x2 Grid Metric Cards
              Row(
                children: [
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pending dues',
                            style: text.bodyMedium?.copyWith(
                              color: AppColors.mute,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₹1.4L',
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
                  const SizedBox(width: 14),
                  Expanded(
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
                          Text(
                            '12',
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
                ],
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Visitors today',
                            style: text.bodyMedium?.copyWith(
                              color: AppColors.mute,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '47',
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
                  const SizedBox(width: 14),
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active users',
                            style: text.bodyMedium?.copyWith(
                              color: AppColors.mute,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '238',
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
                ],
              ),
              const SizedBox(height: 20),

              // Needs Attention Card
              AppCard(
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
                            color: const Color(0xFFFEE2E2), // Light red badge
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
                      'Lift complaint open 3 days · 18 defaulters',
                      style: text.bodyMedium?.copyWith(
                        color: AppColors.mute,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),

      // Bottom Navigation Bar (5 Items: Home, HR, Billing, Reports, More)
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
              context.push('/admin-hr');
            } else if (index == 2) {
              context.push('/accountant-collections');
            } else if (index == 3) {
              context.push('/accountant-reports');
            } else if (index == 4) {
              context.push('/admin-settings');
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
}
