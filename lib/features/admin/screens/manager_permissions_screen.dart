import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class PermissionToggleItem {
  final String key;
  final String title;
  bool isEnabled;

  PermissionToggleItem({
    required this.key,
    required this.title,
    required this.isEnabled,
  });
}

/// Screen: Manager · Permissions (Wireframe Screen for Admin Roles & Permissions setup)
class ManagerPermissionsScreen extends ConsumerStatefulWidget {
  final String roleName;

  const ManagerPermissionsScreen({
    super.key,
    this.roleName = 'Manager',
  });

  @override
  ConsumerState<ManagerPermissionsScreen> createState() => _ManagerPermissionsScreenState();
}

class _ManagerPermissionsScreenState extends ConsumerState<ManagerPermissionsScreen> {
  late final List<PermissionToggleItem> _permissions;

  @override
  void initState() {
    super.initState();
    _permissions = [
      PermissionToggleItem(
        key: 'assign_complaints',
        title: 'Assign complaints',
        isEnabled: true,
      ),
      PermissionToggleItem(
        key: 'post_notices',
        title: 'Post notices',
        isEnabled: true,
      ),
      PermissionToggleItem(
        key: 'approve_bookings',
        title: 'Approve bookings',
        isEnabled: true,
      ),
      PermissionToggleItem(
        key: 'create_bills',
        title: 'Create bills',
        isEnabled: false,
      ),
      PermissionToggleItem(
        key: 'view_reports',
        title: 'View reports',
        isEnabled: true,
      ),
      PermissionToggleItem(
        key: 'manage_users',
        title: 'Manage users (HR)',
        isEnabled: false,
      ),
    ];
  }

  void _handleSavePermissions() {
    final enabledCount = _permissions.where((p) => p.isEnabled).length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.roleName} permissions saved ($enabledCount active)'),
        backgroundColor: const Color(0xFF0F5C4D),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F4), // Matching beige tint background from wireframe
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Screen Title (Manager · permissions)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  Text(
                    '${widget.roleName} · permissions',
                    style: text.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Permissions List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 600));
                },
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  itemCount: _permissions.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _permissions[index];
                    return _buildPermissionCard(item);
                  },
                ),
              ),
            ),

            // Bottom CTA Button: Save permissions
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F5C4D), // Dark Emerald green
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: _handleSavePermissions,
                  child: const Text('Save permissions'),
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
              context.go('/admin-roles');
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

  Widget _buildPermissionCard(PermissionToggleItem item) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              item.title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                fontSize: 16,
              ),
            ),
          ),
          Switch.adaptive(
            value: item.isEnabled,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF0F5C4D), // Dark Emerald green track
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFCBD5E1), // Grey inactive track
            onChanged: (val) {
              setState(() => item.isEnabled = val);
            },
          ),
        ],
      ),
    );
  }
}
