import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class CollectionFlatItem {
  final String flat;
  final String residentName;
  final double amount;
  final String status; // 'pending', 'overdue', 'paid'

  const CollectionFlatItem({
    required this.flat,
    required this.residentName,
    required this.amount,
    required this.status,
  });
}

/// Screen: Collections · Oct (Wireframe Screen for Accountant & Admin Dues Collections)
class CollectionsScreen extends ConsumerStatefulWidget {
  const CollectionsScreen({super.key});

  @override
  ConsumerState<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends ConsumerState<CollectionsScreen> {
  String _selectedTab = 'Pending'; // 'Pending', 'Paid', 'Overdue'

  final List<CollectionFlatItem> _flats = const [
    CollectionFlatItem(
      flat: 'A-101',
      residentName: 'Anita M.',
      amount: 3450,
      status: 'pending',
    ),
    CollectionFlatItem(
      flat: 'C-210',
      residentName: 'Vikas K.',
      amount: 6900,
      status: 'overdue',
    ),
    CollectionFlatItem(
      flat: 'B-402',
      residentName: 'Rahul S.',
      amount: 3450,
      status: 'pending',
    ),
    CollectionFlatItem(
      flat: 'A-204',
      residentName: 'Suresh P.',
      amount: 4200,
      status: 'overdue',
    ),
    CollectionFlatItem(
      flat: 'B-102',
      residentName: 'Mahesh K.',
      amount: 3450,
      status: 'paid',
    ),
    CollectionFlatItem(
      flat: 'C-301',
      residentName: 'Deepak R.',
      amount: 3450,
      status: 'paid',
    ),
  ];

  List<CollectionFlatItem> get _filteredFlats {
    if (_selectedTab == 'Pending') {
      return _flats.where((f) => f.status == 'pending').toList();
    } else if (_selectedTab == 'Paid') {
      return _flats.where((f) => f.status == 'paid').toList();
    } else if (_selectedTab == 'Overdue') {
      return _flats.where((f) => f.status == 'overdue').toList();
    }
    return _flats;
  }

  void _handleSendReminders() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment reminders sent via WhatsApp & SMS to 18 pending flats'),
        backgroundColor: Color(0xFF0F5C4D),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _handleGenerateBills() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
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
              'Generate Monthly Bills',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Generate maintenance bills for November 2026 across 238 registered flats.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.mute,
                  ),
            ),
            const SizedBox(height: 24),
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
                    const SnackBar(
                      content: Text('Maintenance bills for Nov 2026 generated & dispatched!'),
                      backgroundColor: Color(0xFF0F5C4D),
                    ),
                  );
                },
                child: const Text(
                  'Confirm & Dispatch Bills',
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
            // Top Bar: Screen Title (Collections · Oct)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  Text(
                    'Collections · Oct',
                    style: text.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),

            // Segment Filter Tabs (Pending, Paid, Overdue)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _filterTabPill('Pending'),
                  const SizedBox(width: 10),
                  _filterTabPill('Paid'),
                  const SizedBox(width: 10),
                  _filterTabPill('Overdue'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Summary Card (₹1.4L pending · 18 flats)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '₹1.4L pending',
                          style: text.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                            fontSize: 22,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF4E7), // Light amber/peach container
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text(
                            '18 flats',
                            style: TextStyle(
                              color: Color(0xFFC27803),
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Collection Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: const LinearProgressIndicator(
                        value: 0.75,
                        minHeight: 8,
                        backgroundColor: Color(0xFFE2E8F0),
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F5C4D)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Flat Dues List
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF0F5C4D),
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 800));
                  if (mounted) setState(() {});
                },
                child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                itemCount: _filteredFlats.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final flat = _filteredFlats[index];
                  return _buildFlatCard(flat);
                },
              ),
            ),
          ),

            // Bottom Action Buttons (Send reminders & Generate bills)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                children: [
                  // Send Reminders Button (Outlined style with dark emerald border)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0F5C4D),
                        side: const BorderSide(color: Color(0xFF0F5C4D), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: _handleSendReminders,
                      child: const Text('Send reminders'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Generate Bills Button (Solid Dark Emerald CTA)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F5C4D),
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
                      onPressed: _handleGenerateBills,
                      child: const Text('Generate bills'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar (Home, HR, Billing, Reports, More) with 'Billing' active
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
          currentIndex: 2, // 'Billing' active tab
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
              // Already on Billing tab
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

  Widget _buildFlatCard(CollectionFlatItem item) {
    final isOverdue = item.status == 'overdue';
    final isPaid = item.status == 'paid';

    Color badgeBg;
    Color badgeText;
    String badgeLabel;

    if (isOverdue) {
      badgeBg = const Color(0xFFFEE2E2); // Light red
      badgeText = const Color(0xFFEF4444); // Red
      badgeLabel = 'Overdue';
    } else if (isPaid) {
      badgeBg = const Color(0xFFDCFCE7); // Light green
      badgeText = const Color(0xFF16A34A); // Green
      badgeLabel = 'Paid';
    } else {
      badgeBg = const Color(0xFFFDF4E7); // Light peach/amber
      badgeText = const Color(0xFFC27803); // Orange
      badgeLabel = 'Pending';
    }

    final formattedAmount = '₹${item.amount.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Flat number & Resident Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.flat,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.residentName,
                style: const TextStyle(
                  color: AppColors.mute,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Amount & Status Badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formattedAmount,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeLabel,
                  style: TextStyle(
                    color: badgeText,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
