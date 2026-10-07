import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/app_card.dart';

class SuperAdminHomeScreen extends ConsumerStatefulWidget {
  const SuperAdminHomeScreen({super.key});

  @override
  ConsumerState<SuperAdminHomeScreen> createState() => _SuperAdminHomeScreenState();
}

class _SuperAdminHomeScreenState extends ConsumerState<SuperAdminHomeScreen> {
  int _bottomNavIndex = 0;

  final List<Map<String, dynamic>> _societies = [
    {
      'name': 'Demo Housing Society',
      'location': 'Palm Beach Road, Navi Mumbai',
      'flats': '170 Flats',
      'admin': 'Rahul Sharma (Admin)',
      'status': 'ACTIVE',
    },
    {
      'name': 'Greenfield Heights CHS',
      'location': 'Powai, Mumbai',
      'flats': '320 Flats',
      'admin': 'Vikas Patel (Admin)',
      'status': 'ACTIVE',
    },
    {
      'name': 'Royal Palms Residency',
      'location': 'Hiranandani Estate, Thane',
      'flats': '240 Flats',
      'admin': 'Pending Assign',
      'status': 'ONBOARDING',
    },
  ];

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Super Admin Platform Console Updated'),
          backgroundColor: Color(0xFF0F5C4D),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _onboardNewSociety() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Onboard New Society', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            TextField(
              decoration: InputDecoration(
                labelText: 'Society Name',
                hintText: 'e.g. Sunrise Park CHS',
              ),
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Location / City',
                hintText: 'e.g. Bandra West, Mumbai',
              ),
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'First Admin Mobile No',
                hintText: 'e.g. 9876543210',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F5C4D), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Society onboarded! First Admin set successfully.'),
                  backgroundColor: Color(0xFF0F5C4D),
                ),
              );
            },
            child: const Text('Onboard Society'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Super Admin Master Console',
              style: text.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            Text(
              'Platform Owner • ${user?.name ?? "Super Admin"}',
              style: const TextStyle(fontSize: 11, color: AppColors.mute),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.ink),
            onPressed: () => context.push('/admin-settings'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.ink),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF0F5C4D),
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Platform Metrics Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F5C4D),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Platform Metrics',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF0F5C4D),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _onboardNewSociety,
                            icon: const Icon(Icons.add_business_rounded, size: 18),
                            label: const Text('Add Society', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildMetric('14 Societies', 'Active Onboarded'),
                          _buildMetric('3,420 Flats', 'Total Units'),
                          _buildMetric('99.9%', 'Uptime Health'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Registered Housing Societies List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Managed Societies',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF0F5C4D)),
                      onPressed: _onboardNewSociety,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                ..._societies.map((soc) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Color(0xFFE6F4F1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.apartment_rounded, color: Color(0xFF0F5C4D), size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    soc['name'],
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.ink),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${soc['location']} • ${soc['flats']}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.mute),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Admin: ${soc['admin']}',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F5C4D)),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: AppColors.mute),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.line.withValues(alpha: 0.6))),
        ),
        child: BottomNavigationBar(
          currentIndex: _bottomNavIndex,
          selectedItemColor: const Color(0xFF0F5C4D),
          unselectedItemColor: AppColors.mute,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() => _bottomNavIndex = index);
            if (index == 1) context.push('/admin-hr');
            if (index == 2) context.push('/admin-settings');
            if (index == 3) context.push('/profile');
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.apartment_rounded), label: 'Societies'),
            BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'HR Access'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'System'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}
