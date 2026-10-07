import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/models/role_enum.dart';
import '../../../core/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile & Settings (A5)'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 600));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
            // User Avatar & Info Header
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: Text(
                          user.name.substring(0, 1),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${user.blockFlat} • ${user.isOwner ? "Owner" : "Tenant"}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.phone,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Profile Options Menu List
            _sectionHeader(context, 'Resident Management'),
            _menuTile(
              context,
              icon: Icons.family_restroom_outlined,
              title: 'Family Members (B12)',
              subtitle: 'Add or manage family profiles',
              onTap: () => context.push('/family'),
            ),
            _menuTile(
              context,
              icon: Icons.directions_car_outlined,
              title: 'My Vehicles & Parking (B13)',
              subtitle: '2 Vehicles registered • Slot A-402',
              onTap: () => context.push('/vehicles'),
            ),
            _menuTile(
              context,
              icon: Icons.share_outlined,
              title: 'Shared Access & Links (C9)',
              subtitle: 'Manage landlord & delegate access',
              onTap: () => context.push('/shared-access'),
            ),

            const SizedBox(height: 20),
            _sectionHeader(context, 'Active Role & Preferences'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: ListTile(
                leading: const Icon(Icons.swap_horiz_rounded, color: AppColors.primary),
                title: const Text('Active App Role'),
                subtitle: Text('Currently active as: ${user.activeRole.label}'),
                trailing: DropdownButton<UserRole>(
                  value: user.activeRole,
                  underline: const SizedBox(),
                  onChanged: (UserRole? newRole) {
                    if (newRole != null) {
                      ref.read(authProvider.notifier).switchActiveRole(newRole);
                    }
                  },
                  items: user.availableRoles.map((role) {
                    return DropdownMenuItem<UserRole>(
                      value: role,
                      child: Text(role.label),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),
            _sectionHeader(context, 'Support & System'),
            _menuTile(
              context,
              icon: Icons.help_outline_rounded,
              title: 'Help & Support (B14)',
              subtitle: 'Contact society office or view FAQs',
              onTap: () => context.push('/help'),
            ),
            _menuTile(
              context,
              icon: Icons.info_outline,
              title: 'About SocietyHub',
              subtitle: 'Version 1.0.0+1 • Master Screen Inventory',
              onTap: () {},
            ),

            const SizedBox(height: 28),

            // Logout Button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Logout from Account'),
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                context.go('/login');
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _menuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      ),
    );
  }
}
