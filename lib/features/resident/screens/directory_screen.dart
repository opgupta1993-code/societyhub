import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class ResidentContact {
  final String name;
  final String flat;
  final String tower;
  final String role; // 'Owner' or 'Tenant'
  final String phone;

  const ResidentContact({
    required this.name,
    required this.flat,
    required this.tower,
    required this.role,
    required this.phone,
  });
}

/// Module 10: Directory & Documents - Society Resident Directory
class DirectoryScreen extends ConsumerStatefulWidget {
  const DirectoryScreen({super.key});

  @override
  ConsumerState<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends ConsumerState<DirectoryScreen> {
  final _searchController = TextEditingController();
  String _selectedTower = 'All';

  final List<ResidentContact> _allResidents = const [
    ResidentContact(name: 'Amitabh Sen', flat: 'A-101', tower: 'A', role: 'Owner', phone: '+91 98230 11221'),
    ResidentContact(name: 'Sunita Mehra', flat: 'A-102', tower: 'A', role: 'Tenant', phone: '+91 98230 11222'),
    ResidentContact(name: 'Karan Malhotra', flat: 'A-201', tower: 'A', role: 'Owner', phone: '+91 98230 11223'),
    ResidentContact(name: 'Rahul Sharma', flat: 'B-402', tower: 'B', role: 'Tenant', phone: '+91 98765 43210'),
    ResidentContact(name: 'Virendra Singh', flat: 'B-403', tower: 'B', role: 'Owner', phone: '+91 98230 11225'),
    ResidentContact(name: 'Deepak Joshi', flat: 'B-501', tower: 'B', role: 'Owner', phone: '+91 98230 11226'),
    ResidentContact(name: 'Meena Kulkarni', flat: 'C-204', tower: 'C', role: 'Owner', phone: '+91 98230 11227'),
    ResidentContact(name: 'Rajesh Patel', flat: 'C-302', tower: 'C', role: 'Tenant', phone: '+91 98230 11228'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final towers = ['All', 'Tower A', 'Tower B', 'Tower C'];

    final filtered = _allResidents.where((r) {
      final matchesTower = _selectedTower == 'All' || 'Tower ${r.tower}' == _selectedTower;
      final matchesSearch = query.isEmpty ||
          r.name.toLowerCase().contains(query) ||
          r.flat.toLowerCase().contains(query);
      return matchesTower && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Society Directory', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xFF0F5C4D),
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 600));
          if (mounted) setState(() {});
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            // Search Input Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 2)),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  icon: Icon(Icons.search_rounded, color: Color(0xFF0F5C4D)),
                  border: InputBorder.none,
                  hintText: 'Search by resident name or flat (e.g. B-402)',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tower Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: towers.map((t) {
                  final isSelected = _selectedTower == t;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(t),
                      selected: isSelected,
                      selectedColor: const Color(0xFF0F5C4D),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.ink,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedTower = t);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Residents (${filtered.length})',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ink),
                ),
                TextButton.icon(
                  onPressed: () => context.push('/contacts'),
                  icon: const Icon(Icons.phone_in_talk_rounded, size: 16, color: Color(0xFF0F5C4D)),
                  label: const Text('Emergency Contacts', style: TextStyle(color: Color(0xFF0F5C4D), fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...filtered.map((r) => _buildResidentCard(r)),
          ],
        ),
      ),
    );
  }

  Widget _buildResidentCard(ResidentContact r) {
    final isOwner = r.role == 'Owner';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF0F5C4D).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  r.flat,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF0F5C4D)),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        r.name,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.ink),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (isOwner ? Colors.blue : Colors.teal).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          r.role,
                          style: TextStyle(
                            color: isOwner ? Colors.blue : Colors.teal,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tower ${r.tower} • ${r.phone}',
                    style: const TextStyle(color: AppColors.mute, fontSize: 12),
                  ),
                ],
              ),
            ),
            // Call & Chat buttons
            IconButton(
              icon: const Icon(Icons.call_rounded, color: Colors.green, size: 22),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Calling ${r.name} (${r.phone})...'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF0F5C4D), size: 20),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening chat with ${r.name}...'),
                    backgroundColor: const Color(0xFF0F5C4D),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
