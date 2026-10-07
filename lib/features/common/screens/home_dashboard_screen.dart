import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/models/role_enum.dart';
import '../../../core/providers/auth_provider.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final currentLocale = ref.watch(localeProvider);
    final user = authState.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final activeRole = user.activeRole;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.societyName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              user.blockFlat,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          // Language Switcher Dropdown
          PopupMenuButton<String>(
            icon: const Icon(Icons.language_rounded, color: AppColors.primary),
            tooltip: context.tr('switch_language'),
            onSelected: (String langCode) {
              ref.read(localeProvider.notifier).changeLocale(langCode);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'en',
                child: Row(
                  children: [
                    if (currentLocale.languageCode == 'en') const Icon(Icons.check, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    const Text('English'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'hi',
                child: Row(
                  children: [
                    if (currentLocale.languageCode == 'hi') const Icon(Icons.check, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    const Text('हिंदी (Hindi)'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'mr',
                child: Row(
                  children: [
                    if (currentLocale.languageCode == 'mr') const Icon(Icons.check, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    const Text('मराठी (Marathi)'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'gu',
                child: Row(
                  children: [
                    if (currentLocale.languageCode == 'gu') const Icon(Icons.check, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    const Text('ગુજરાતી (Gujarati)'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
            tooltip: 'A4 Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
            tooltip: 'A5 Profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Role Switching Banner
            _buildRoleBanner(context, ref, user),
            const SizedBox(height: 20),

            // Role-Specific KPI Cards
            _buildKpiSection(context, activeRole),
            const SizedBox(height: 24),

            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${context.tr('quick_actions')} (${activeRole.label})',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
                Text(
                  'Role Code: ${activeRole.code}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getRoleColor(activeRole),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Dynamic Action Grid by Active Role
            _buildActionGrid(context, activeRole),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleBanner(BuildContext context, WidgetRef ref, dynamic user) {
    final activeRole = user.activeRole as UserRole;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getRoleColor(activeRole).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getRoleColor(activeRole).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _getRoleColor(activeRole),
              shape: BoxShape.circle,
            ),
            child: Icon(_getRoleIcon(activeRole), color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getRoleColor(activeRole),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        activeRole.label,
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  activeRole.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          PopupMenuButton<UserRole>(
            icon: const Icon(Icons.swap_horiz_rounded, color: AppColors.primary),
            tooltip: 'Switch Active Role',
            onSelected: (UserRole newRole) {
              ref.read(authProvider.notifier).switchActiveRole(newRole);
            },
            itemBuilder: (context) => user.availableRoles.map<PopupMenuEntry<UserRole>>((UserRole role) {
              return PopupMenuItem<UserRole>(
                value: role,
                child: Row(
                  children: [
                    Icon(_getRoleIcon(role), color: _getRoleColor(role), size: 20),
                    const SizedBox(width: 12),
                    Text(role.label),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiSection(BuildContext context, UserRole role) {
    switch (role) {
      case UserRole.resident:
        return Row(
          children: [
            _kpiCard(context, context.tr('pending_dues'), '₹ 2,450', 'B1: My Accounts', Colors.orange, Icons.account_balance_wallet_outlined),
            const SizedBox(width: 12),
            _kpiCard(context, context.tr('gate_passes'), '2 Active', 'B3: Visitors', Colors.blue, Icons.qr_code_rounded),
          ],
        );
      case UserRole.admin:
        return Row(
          children: [
            _kpiCard(context, 'Total Users', '248 Members', 'D2: HR List', Colors.purple, Icons.people_alt_outlined),
            const SizedBox(width: 12),
            _kpiCard(context, 'Collections', '94% Paid', 'D1: Dashboard', Colors.green, Icons.analytics_outlined),
          ],
        );
      case UserRole.manager:
        return Row(
          children: [
            _kpiCard(context, 'Complaints Queue', '5 Urgent', 'E2: Complaints', Colors.red, Icons.build_outlined),
            const SizedBox(width: 12),
            _kpiCard(context, 'Slot Approvals', '3 Pending', 'E4: Bookings', Colors.teal, Icons.event_available_outlined),
          ],
        );
      case UserRole.accountant:
        return Row(
          children: [
            _kpiCard(context, 'Month Defaulters', '12 Flats', 'F1: Accounts', Colors.deepOrange, Icons.warning_amber_rounded),
            const SizedBox(width: 12),
            _kpiCard(context, 'Month Expenses', '₹ 1.85 L', 'F4: Expenses', Colors.indigo, Icons.receipt_long_outlined),
          ],
        );
      case UserRole.committee:
        return Row(
          children: [
            _kpiCard(context, 'Active Poll', 'AGM Agenda', 'G2: Polls', Colors.pink, Icons.poll_outlined),
            const SizedBox(width: 12),
            _kpiCard(context, 'Next Meeting', '10th Oct', 'G4: Meetings', Colors.brown, Icons.groups_outlined),
          ],
        );
      case UserRole.guard:
        return Row(
          children: [
            _kpiCard(context, 'Inside Society', '18 Visitors', 'H1: Guard Console', Colors.blueGrey, Icons.sensor_door_outlined),
            const SizedBox(width: 12),
            _kpiCard(context, 'Today Walk-ins', '42 Entered', 'H4: Gate Log', Colors.teal, Icons.badge_outlined),
          ],
        );
      case UserRole.superAdmin:
        return Row(
          children: [
            _kpiCard(context, 'Societies', '14 Active', 'Onboarded', Colors.indigo, Icons.apartment_outlined),
            const SizedBox(width: 12),
            _kpiCard(context, 'Platform Users', '3,420 Total', 'All Units', Colors.teal, Icons.people_outline),
          ],
        );
    }
  }

  Widget _kpiCard(BuildContext context, String title, String value, String subtext, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 22),
                Text(subtext, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 2),
            Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context, UserRole role) {
    final tiles = _getTilesForRole(context, role);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: tiles.length,
      itemBuilder: (context, index) {
        final item = tiles[index];
        return InkWell(
          onTap: () => context.push(item.route),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon, color: item.color, size: 22),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.id,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<_TileData> _getTilesForRole(BuildContext context, UserRole role) {
    switch (role) {
      case UserRole.resident:
        return [
          _TileData('B1', context.tr('pending_dues'), 'UPI, Card, Netbanking', Icons.payment_outlined, Colors.blue, '/dues'),
          _TileData('B2', context.tr('complaints'), 'Raise issue, upload photo', Icons.build_circle_outlined, Colors.orange, '/complaints'),
          _TileData('B3', context.tr('gate_passes'), 'QR Pass, invite guests', Icons.qr_code_scanner_rounded, Colors.green, '/visitors'),
          _TileData('B5', context.tr('notices'), 'Society announcements', Icons.campaign_outlined, Colors.purple, '/notices'),
          _TileData('B6', context.tr('polls'), 'Participate & see results', Icons.how_to_vote_outlined, Colors.teal, '/polls'),
          _TileData('B7', context.tr('amenity_booking'), 'Club house, slots', Icons.sports_tennis_outlined, Colors.indigo, '/amenities'),
          _TileData('C1', context.tr('records_hub'), 'Rent, receipts, statements', Icons.folder_shared_outlined, Colors.amber, '/records-hub'),
          _TileData('B9', context.tr('directory'), 'Search contacts & call', Icons.contacts_outlined, Colors.blueGrey, '/directory'),
        ];
      case UserRole.admin:
        return [
          _TileData('D2', 'User HR List', 'Search & filter by role', Icons.people_outline, Colors.purple, '/admin-hr'),
          _TileData('D5', 'Roles & Permissions', 'Configure role caps', Icons.admin_panel_settings_outlined, Colors.deepPurple, '/admin-roles'),
          _TileData('D6', 'Society Settings', 'Flats, rates, gateway', Icons.tune_outlined, Colors.blue, '/admin-settings'),
          _TileData('D7', 'Audit Log', 'Data & role change history', Icons.history_edu_outlined, Colors.blueGrey, '/admin-audit'),
        ];
      case UserRole.manager:
        return [
          _TileData('E2', 'Complaint Queue', 'Filter by priority & staff', Icons.assignment_outlined, Colors.red, '/manager-complaints'),
          _TileData('E4', 'Booking Approvals', 'Approve/reject calendar', Icons.event_available_outlined, Colors.teal, '/manager-approvals'),
          _TileData('E5', 'Create Notice', 'Target audience & push', Icons.post_add_outlined, Colors.orange, '/manager-create-notice'),
        ];
      case UserRole.accountant:
        return [
          _TileData('F2', 'Generate Bills', 'Batch monthly maintenance', Icons.receipt_long_outlined, Colors.green, '/accountant-bills'),
          _TileData('F3', 'Collections', 'Paid, pending, cash entry', Icons.account_balance_wallet_outlined, Colors.teal, '/accountant-collections'),
          _TileData('F4', 'Log Expenses', 'Add bill & photo proof', Icons.request_quote_outlined, Colors.indigo, '/accountant-expenses'),
          _TileData('F5', 'Reports', 'P&L, Balance Sheet, Excel', Icons.analytics_outlined, Colors.deepOrange, '/accountant-reports'),
        ];
      case UserRole.committee:
        return [
          _TileData('G2', 'Create Poll', 'Question & options', Icons.poll_outlined, Colors.pink, '/committee-polls'),
          _TileData('G4', 'Meetings & MoM', 'Schedule AGM & minutes', Icons.groups_outlined, Colors.brown, '/committee-meetings'),
        ];
      case UserRole.guard:
        return [
          _TileData('H2', 'Walk-in Entry', 'Capture name, flat, photo', Icons.badge_outlined, Colors.blue, '/guard-walkin'),
          _TileData('H3', 'Approval Status', 'Resident live response', Icons.hourglass_top_outlined, Colors.amber, '/guard-approval-status'),
          _TileData('H4', 'Gate Logbook', 'In/Out exit marker', Icons.list_alt_outlined, Colors.green, '/guard-log'),
          _TileData('H5', 'Vehicle & Staff', 'RFID / Blacklist check', Icons.directions_car_outlined, Colors.red, '/guard-vehicle-check'),
        ];
      case UserRole.superAdmin:
        return [
          _TileData('S1', 'Societies', 'Manage & Onboard', Icons.apartment_outlined, Colors.indigo, '/home'),
          _TileData('S2', 'Global HR', 'User & Admin Access', Icons.people_outline, Colors.purple, '/admin-hr'),
          _TileData('S3', 'System Settings', 'Gateway & Config', Icons.tune_outlined, Colors.blue, '/admin-settings'),
        ];
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.superAdmin: return Colors.indigo;
      case UserRole.resident: return AppColors.roleResident;
      case UserRole.admin: return AppColors.roleAdmin;
      case UserRole.manager: return AppColors.roleManager;
      case UserRole.accountant: return AppColors.roleAccountant;
      case UserRole.committee: return AppColors.roleCommittee;
      case UserRole.guard: return AppColors.roleGuard;
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.superAdmin: return Icons.domain_rounded;
      case UserRole.resident: return Icons.home_rounded;
      case UserRole.admin: return Icons.admin_panel_settings_rounded;
      case UserRole.manager: return Icons.manage_accounts_rounded;
      case UserRole.accountant: return Icons.account_balance_rounded;
      case UserRole.committee: return Icons.gavel_rounded;
      case UserRole.guard: return Icons.security_rounded;
    }
  }
}

class _TileData {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  _TileData(this.id, this.title, this.subtitle, this.icon, this.color, this.route);
}
