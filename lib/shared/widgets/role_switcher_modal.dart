import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/models/role_enum.dart';
import '../../core/providers/auth_provider.dart';

class RoleSwitcherModal extends ConsumerWidget {
  const RoleSwitcherModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => const RoleSwitcherModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final authState = ref.watch(authProvider);
    final user = authState.user;

    if (user == null) return const SizedBox.shrink();

    final activeRole = user.activeRole;
    final availableRoles = user.availableRoles;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle bar
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Modal Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F4F1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.swap_horiz_rounded, color: Color(0xFF0F5C4D), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Switch Active Role',
                      style: text.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Multi-Role Account (${availableRoles.length} Roles Assigned)',
                      style: const TextStyle(fontSize: 12, color: AppColors.mute),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // List of Assigned Roles
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: availableRoles.map((role) {
                  final isSelected = role == activeRole;
                  final roleColor = _getRoleColor(role);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        ref.read(authProvider.notifier).switchActiveRole(role);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Switched to ${role.label} Console (${role.code})'),
                            backgroundColor: const Color(0xFF0F5C4D),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected ? roleColor.withValues(alpha: 0.08) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? roleColor : AppColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: roleColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(_getRoleIcon(role), color: roleColor, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        role.label,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                          color: isSelected ? roleColor : AppColors.ink,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: roleColor.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'ID: ${role.roleId}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: roleColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    role.description,
                                    style: const TextStyle(fontSize: 12, color: AppColors.mute),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle_rounded, color: roleColor, size: 24),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.superAdmin: return Colors.indigo;
      case UserRole.admin: return AppColors.roleAdmin;
      case UserRole.manager: return AppColors.roleManager;
      case UserRole.resident: return AppColors.roleResident;
      case UserRole.accountant: return AppColors.roleAccountant;
      case UserRole.committee: return AppColors.roleCommittee;
      case UserRole.guard: return AppColors.roleGuard;
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.superAdmin: return Icons.domain_rounded;
      case UserRole.admin: return Icons.admin_panel_settings_rounded;
      case UserRole.manager: return Icons.manage_accounts_rounded;
      case UserRole.resident: return Icons.home_rounded;
      case UserRole.accountant: return Icons.account_balance_rounded;
      case UserRole.committee: return Icons.gavel_rounded;
      case UserRole.guard: return Icons.security_rounded;
    }
  }
}
