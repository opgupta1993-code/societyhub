import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/role_switcher_chip.dart';

class GuardHomeScreen extends ConsumerStatefulWidget {
  const GuardHomeScreen({super.key});

  @override
  ConsumerState<GuardHomeScreen> createState() => _GuardHomeScreenState();
}

class _GuardHomeScreenState extends ConsumerState<GuardHomeScreen> {
  int _bottomNavIndex = 0;

  final List<Map<String, dynamic>> _visitorLogs = [
    {
      'id': 'LOG-101',
      'name': 'Rohan Deshmukh',
      'type': 'Delivery (Swiggy)',
      'flat': 'Tower B - 402',
      'time': '10 mins ago',
      'status': 'ENTERED',
      'passCode': 'GP-8842',
    },
    {
      'id': 'LOG-102',
      'name': 'Mahesh Kumar',
      'type': 'Cab (Uber)',
      'flat': 'Tower A - 105',
      'time': '25 mins ago',
      'status': 'WAITING',
      'passCode': 'GP-9912',
    },
    {
      'id': 'LOG-103',
      'name': 'Ramesh Carpenter',
      'type': 'Service Staff',
      'flat': 'Tower C - 601',
      'time': '1 hour ago',
      'status': 'EXITED',
      'passCode': 'GP-1104',
    },
  ];

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Guard Gate Console Updated'),
          backgroundColor: Color(0xFF0F5C4D),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _scanQrCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF0F5C4D)),
            SizedBox(width: 8),
            Text('QR Gate Pass Scanner'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF0F5C4D), width: 2),
              ),
              child: const Center(
                child: Icon(Icons.qr_code_2_rounded, size: 100, color: Color(0xFF0F5C4D)),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Align Visitor QR Pass inside camera frame',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F5C4D),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gate Pass Verified: Entry Approved for Tower B-402!'),
                  backgroundColor: Color(0xFF0F5C4D),
                ),
              );
            },
            child: const Text('Simulate Scan Pass'),
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
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFE6F4F1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.security_rounded, color: Color(0xFF0F5C4D), size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Main Gate Security',
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  'Guard Console • ${user?.name ?? "Guard Officer"}',
                  style: const TextStyle(fontSize: 11, color: AppColors.mute),
                ),
              ],
            ),
          ],
        ),
        actions: [
          const RoleSwitcherChip(),
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
                // Scan QR Gate Pass Banner CTA
                GestureDetector(
                  onTap: _scanQrCode,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F5C4D), Color(0xFF1B8A74)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F5C4D).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 36),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Scan Visitor Pass',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Tap to open QR code gate scanner & approve entry',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Action Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionCard(
                        icon: Icons.person_add_alt_1_rounded,
                        title: 'Walk-in Entry',
                        subtitle: 'Register new visitor',
                        color: Colors.blue,
                        onTap: () => context.push('/guard-walkin'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionCard(
                        icon: Icons.directions_car_filled_rounded,
                        title: 'Vehicle Check',
                        subtitle: 'RFID & Parking slot',
                        color: Colors.deepOrange,
                        onTap: () => context.push('/guard-vehicle-check'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Live Gate Activity Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Live Gate Activity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      '3 Active',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F5C4D)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Visitor Activity List
                ..._visitorLogs.map((log) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildVisitorCard(log),
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
            if (index == 1) context.push('/guard-walkin');
            if (index == 2) context.push('/guard-log');
            if (index == 3) context.push('/profile');
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.security_rounded), label: 'Gate'),
            BottomNavigationBarItem(icon: Icon(Icons.person_add_rounded), label: 'Walk-in'),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'Logbook'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.ink),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: AppColors.mute),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitorCard(Map<String, dynamic> log) {
    final status = log['status'] as String;
    final isEntered = status == 'ENTERED';

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isEntered ? Colors.green.shade50 : Colors.amber.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isEntered ? Icons.check_circle_outline_rounded : Icons.hourglass_top_rounded,
              color: isEntered ? Colors.green.shade700 : Colors.amber.shade800,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      log['name'],
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.ink),
                    ),
                    Text(
                      log['time'],
                      style: const TextStyle(fontSize: 11, color: AppColors.mute),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${log['type']} • ${log['flat']}',
                  style: const TextStyle(fontSize: 13, color: AppColors.mute, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isEntered ? const Color(0xFFE6F4F1) : Colors.amber.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: isEntered ? const Color(0xFF0F5C4D) : Colors.amber.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
