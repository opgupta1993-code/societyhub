import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class HrUserItem {
  final String id;
  final String name;
  final String subtitle;
  final String roleLabel;
  final String category; // 'resident', 'manager', 'guard', 'accountant'

  const HrUserItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.roleLabel,
    required this.category,
  });
}

/// Screen: HR · Users (Admin User & Staff Management Screen)
class HrUsersScreen extends ConsumerStatefulWidget {
  const HrUsersScreen({super.key});

  @override
  ConsumerState<HrUsersScreen> createState() => _HrUsersScreenState();
}

class _HrUsersScreenState extends ConsumerState<HrUsersScreen> {
  String _selectedTab = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<HrUserItem> _allUsers = const [
    HrUserItem(
      id: '1',
      name: 'Rahul S.',
      subtitle: 'B-402 · Tenant',
      roleLabel: 'Resident',
      category: 'resident',
    ),
    HrUserItem(
      id: '2',
      name: 'Anita M.',
      subtitle: 'A-101 · Owner',
      roleLabel: 'Manager',
      category: 'manager',
    ),
    HrUserItem(
      id: '3',
      name: 'Sunil K.',
      subtitle: 'Office',
      roleLabel: 'Accountant',
      category: 'manager',
    ),
    HrUserItem(
      id: '4',
      name: 'Ramesh',
      subtitle: 'Main gate',
      roleLabel: 'Guard',
      category: 'guard',
    ),
    HrUserItem(
      id: '5',
      name: 'Vikas K.',
      subtitle: 'A-204 · Tenant',
      roleLabel: 'Resident',
      category: 'resident',
    ),
    HrUserItem(
      id: '6',
      name: 'Suresh Kumar',
      subtitle: 'Tower C - 104 · Owner',
      roleLabel: 'Resident',
      category: 'resident',
    ),
    HrUserItem(
      id: '7',
      name: 'Prakash Sharma',
      subtitle: 'Gate 2 Desk',
      roleLabel: 'Guard',
      category: 'guard',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<HrUserItem> get _filteredUsers {
    return _allUsers.where((user) {
      // Tab Filter
      if (_selectedTab == 'Managers' && user.category != 'manager') {
        return false;
      }
      if (_selectedTab == 'Guards' && user.category != 'guard') {
        return false;
      }

      // Search Query Filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final nameMatches = user.name.toLowerCase().contains(query);
        final subtitleMatches = user.subtitle.toLowerCase().contains(query);
        final roleMatches = user.roleLabel.toLowerCase().contains(query);
        return nameMatches || subtitleMatches || roleMatches;
      }

      return true;
    }).toList();
  }

  void _showAddUserDialog() {
    final nameCtrl = TextEditingController();
    final flatCtrl = TextEditingController();
    String selectedRole = 'Resident';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Add New User / Staff',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: flatCtrl,
                decoration: InputDecoration(
                  labelText: 'Flat / Designation (e.g. B-402 or Main gate)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedRole,
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'Resident', child: Text('Resident')),
                  DropdownMenuItem(value: 'Manager', child: Text('Manager')),
                  DropdownMenuItem(value: 'Accountant', child: Text('Accountant')),
                  DropdownMenuItem(value: 'Guard', child: Text('Guard')),
                ],
                onChanged: (val) {
                  if (val != null) setModalState(() => selectedRole = val);
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F5C4D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('User "${nameCtrl.text.isNotEmpty ? nameCtrl.text : 'New User'}" added successfully'),
                        backgroundColor: const Color(0xFF0F5C4D),
                      ),
                    );
                  },
                  child: const Text(
                    'Save User',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
            // Top Bar: Title & + Add Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'HR · Users',
                    style: text.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                      fontSize: 26,
                    ),
                  ),
                  InkWell(
                    onTap: _showAddUserDialog,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F4F1), // Light mint container
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '+ Add',
                        style: TextStyle(
                          color: Color(0xFF0F5C4D), // Dark Emerald text
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() => _searchQuery = val);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search name or flat',
                    hintStyle: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Color(0xFF6B21A8), // Purple magnifying glass icon
                      size: 22,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Filter Tabs Row (All, Managers, Guards)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _filterTabPill('All'),
                  const SizedBox(width: 10),
                  _filterTabPill('Managers'),
                  const SizedBox(width: 10),
                  _filterTabPill('Guards'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Users List
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF0F5C4D),
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 800));
                  if (mounted) setState(() {});
                },
                child: _filteredUsers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search_outlined, size: 56, color: AppColors.mute.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          Text(
                            'No users found',
                            style: text.bodyLarge?.copyWith(
                              color: AppColors.mute,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      itemCount: _filteredUsers.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        return _buildUserCard(user);
                      },
                    ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar (Home, HR, Billing, Reports, More)
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
          currentIndex: 1, // 'HR' active tab
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
              // Already on HR tab
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

  Widget _filterTabPill(String title) {
    final isActive = _selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedTab = title);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0F5C4D) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF0F5C4D).withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF475569),
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(HrUserItem user) {
    // Initial letter for circle avatar
    final initialLetter = user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U';

    // Role badge color styling
    final isResident = user.roleLabel.toLowerCase() == 'resident';
    final badgeBg = isResident ? const Color(0xFFE6F4F1) : const Color(0xFFFDF4E7);
    final badgeText = isResident ? const Color(0xFF0F5C4D) : const Color(0xFFC27803);

    return GestureDetector(
      onTap: () {
        context.push('/assign-role', extra: user);
      },
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Circular Avatar (Light teal background with initial letter)
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFE6F4F1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initialLetter,
                style: const TextStyle(
                  color: Color(0xFF0F5C4D),
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.subtitle,
                  style: const TextStyle(
                    color: AppColors.mute,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Role Badge Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              user.roleLabel,
              style: TextStyle(
                color: badgeText,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    ),
  );
  }
}
