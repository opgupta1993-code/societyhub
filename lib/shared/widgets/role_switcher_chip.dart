import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/role_enum.dart';
import '../../core/providers/auth_provider.dart';
import 'role_switcher_modal.dart';

class RoleSwitcherChip extends ConsumerWidget {
  const RoleSwitcherChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    if (user == null) return const SizedBox.shrink();

    final activeRole = user.activeRole;
    final availableRoles = user.availableRoles;
    final isMultiRole = availableRoles.length > 1;

    final roleColor = _getRoleColor(activeRole);

    return GestureDetector(
      onTap: () => RoleSwitcherModal.show(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: roleColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: roleColor.withValues(alpha: 0.4), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getRoleIcon(activeRole), color: roleColor, size: 16),
            const SizedBox(width: 6),
            Text(
              activeRole.label,
              style: TextStyle(
                color: roleColor,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            if (isMultiRole) ...[
              const SizedBox(width: 4),
              Icon(Icons.arrow_drop_down_rounded, color: roleColor, size: 18),
            ],
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.superAdmin: return Colors.indigo;
      case UserRole.admin: return const Color(0xFF0F5C4D);
      case UserRole.manager: return Colors.deepOrange;
      case UserRole.resident: return Colors.blue;
      case UserRole.accountant: return Colors.teal;
      case UserRole.committee: return Colors.purple;
      case UserRole.guard: return Colors.blueGrey;
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
