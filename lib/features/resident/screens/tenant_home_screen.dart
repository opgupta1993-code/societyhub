import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/language_selection_modal.dart';
import '../../../shared/widgets/logout_dialog.dart';
import '../../../shared/widgets/role_switcher_chip.dart';

/// Screen: Tenant Home Dashboard (from wireframe image)
class TenantHomeScreen extends ConsumerStatefulWidget {
  const TenantHomeScreen({super.key});

  @override
  ConsumerState<TenantHomeScreen> createState() => _TenantHomeScreenState();
}

class _TenantHomeScreenState extends ConsumerState<TenantHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final authState = ref.watch(authProvider);
    final user = authState.user;

    final userName = user?.name ?? 'Rahul';
    final blockFlat = user?.blockFlat ?? 'B–402';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
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
                        'Welcome',
                        style: text.bodyMedium?.copyWith(
                          color: AppColors.mute,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$userName · $blockFlat',
                        style: text.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                          fontSize: 22,
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
                      // Notification Bell
                      InkWell(
                        onTap: () => context.push('/notifications'),
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AppColors.tint,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_active_rounded,
                            color: AppColors.amber,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Hero Rent Card (Dark Teal Rounded Box)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rent due · 5 Oct',
                      style: text.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹18,000',
                      style: text.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onPressed: () => context.push('/rent'),
                        child: const Text('Pay rent'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Middle Stat Cards (Society dues & Agreement ends)
              Row(
                children: [
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Society dues',
                            style: text.bodySmall?.copyWith(
                              color: AppColors.mute,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '₹3,450',
                            style: text.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Agreement ends',
                            style: text.bodySmall?.copyWith(
                              color: AppColors.mute,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Mar '27",
                            style: text.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Quick Action Tiles (Issue, Visitors, Booking, Share)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _actionTile(
                    context,
                    icon: Icons.build_outlined,
                    label: 'Issue',
                    onTap: () => context.push('/complaints'),
                  ),
                  _actionTile(
                    context,
                    icon: Icons.door_front_door_outlined,
                    label: 'Visitors',
                    onTap: () => context.push('/visitors'),
                  ),
                  _actionTile(
                    context,
                    icon: Icons.pool_outlined,
                    label: 'Booking',
                    onTap: () => context.push('/amenities'),
                  ),
                  _actionTile(
                    context,
                    icon: Icons.link_rounded,
                    label: 'Share',
                    onTap: () => context.push('/shared-access'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tenancy Info Card
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Tenancy',
                                style: text.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.tint,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Active',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Owner: Mr. Sharma · Tower B, 402',
                            style: text.bodySmall?.copyWith(
                              color: AppColors.mute,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    bottomNavigationBar: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line, width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.home_outlined, Icons.home_rounded, 'Home'),
              _navItem(1, Icons.currency_rupee_rounded, Icons.currency_rupee_rounded, 'Rent', route: '/rent'),
              _navItem(2, Icons.article_outlined, Icons.article_rounded, 'Docs', route: '/documents'),
              _navItem(3, Icons.sentiment_satisfied_alt_rounded, Icons.sentiment_satisfied_alt_rounded, 'Profile', route: '/profile'),
            ],
          ),
        ),
      ),
    ),
  );
  }

  Widget _actionTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.tint,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.mute,
          ),
        ),
      ],
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label, {String? route}) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () {
        setState(() => _currentIndex = index);
        if (route != null) {
          context.push(route);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? AppColors.primary : AppColors.mute,
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.mute,
            ),
          ),
        ],
      ),
    );
  }
}
