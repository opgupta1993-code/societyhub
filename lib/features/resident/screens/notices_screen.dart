import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/models/role_enum.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/app_card.dart';

class NoticeItem {
  final String id;
  final String title;
  final String category;
  final String date;
  final String postedBy;
  final String content;
  final bool isUrgent;
  final bool hasRsvp;
  String? residentRsvpStatus;

  NoticeItem({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.postedBy,
    required this.content,
    this.isUrgent = false,
    this.hasRsvp = false,
    this.residentRsvpStatus,
  });
}

/// Module 8: Notices & Polls - Society Notice Board & Announcements
class NoticesScreen extends ConsumerStatefulWidget {
  const NoticesScreen({super.key});

  @override
  ConsumerState<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends ConsumerState<NoticesScreen> {
  String _selectedCategory = 'All';

  final List<NoticeItem> _notices = [
    NoticeItem(
      id: '1',
      title: 'Scheduled Water Supply Maintenance',
      category: 'Maintenance',
      date: 'Today, 10:00 AM',
      postedBy: 'Estate Manager',
      content: 'Water supply to Tower B and Tower C will remain suspended tomorrow between 2:00 PM and 6:00 PM for underground tank cleaning.',
      isUrgent: true,
      hasRsvp: false,
    ),
    NoticeItem(
      id: '2',
      title: 'Annual General Body Meeting (AGM) 2026',
      category: 'Meetings',
      date: 'Yesterday',
      postedBy: 'Managing Committee',
      content: 'The 12th AGM will be held on Sunday, 25th October at 10:30 AM in the Clubhouse Hall. Agenda includes audited balance sheet and lift modernization approval.',
      isUrgent: false,
      hasRsvp: true,
      residentRsvpStatus: 'Attending',
    ),
    NoticeItem(
      id: '3',
      title: 'Diwali Mela & Cultural Evening Celebration',
      category: 'Events',
      date: '08 Oct 2026',
      postedBy: 'Cultural Committee',
      content: 'Join us for Diwali festivities on 1st November from 6:00 PM on the Central Lawn. Stalls, games, and dinner included.',
      isUrgent: false,
      hasRsvp: true,
      residentRsvpStatus: null,
    ),
    NoticeItem(
      id: '4',
      title: 'EV Charging Station Policy Enacted',
      category: 'General',
      date: '04 Oct 2026',
      postedBy: 'Society Secretary',
      content: 'Residents installing EV chargers in their allotted parking slots must obtain prior NOC from the society office for electrical load audit.',
      isUrgent: false,
      hasRsvp: false,
    ),
  ];

  void _showCreateNoticeModal() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String category = 'Maintenance';
    bool urgent = false;
    bool enableRsvp = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Broadcast Notice',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleCtrl,
                    decoration: InputDecoration(
                      labelText: 'Notice Headline',
                      hintText: 'e.g. Lift Servicing Alert',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Maintenance', child: Text('Maintenance')),
                      DropdownMenuItem(value: 'Meetings', child: Text('Meetings & AGM')),
                      DropdownMenuItem(value: 'Events', child: Text('Celebration & Events')),
                      DropdownMenuItem(value: 'General', child: Text('General Advisory')),
                    ],
                    onChanged: (val) {
                      if (val != null) setModalState(() => category = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: contentCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Notice Details',
                      hintText: 'Type notice content to broadcast to all residents...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SwitchListTile(
                          title: const Text('Mark Urgent', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          value: urgent,
                          activeThumbColor: Colors.red,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (v) => setModalState(() => urgent = v),
                        ),
                      ),
                      Expanded(
                        child: SwitchListTile(
                          title: const Text('Enable RSVP', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          value: enableRsvp,
                          activeThumbColor: const Color(0xFF0F5C4D),
                          contentPadding: EdgeInsets.zero,
                          onChanged: (v) => setModalState(() => enableRsvp = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F5C4D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        if (titleCtrl.text.trim().isNotEmpty) {
                          setState(() {
                            _notices.insert(
                              0,
                              NoticeItem(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                title: titleCtrl.text.trim(),
                                category: category,
                                date: 'Just now',
                                postedBy: 'Society Management',
                                content: contentCtrl.text.trim(),
                                isUrgent: urgent,
                                hasRsvp: enableRsvp,
                              ),
                            );
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notice broadcasted to all residents!'),
                              backgroundColor: Color(0xFF0F5C4D),
                            ),
                          );
                        }
                      },
                      child: const Text('Publish Notice', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final isPrivileged = user?.activeRole == UserRole.admin ||
        user?.activeRole == UserRole.superAdmin ||
        user?.activeRole == UserRole.manager ||
        user?.activeRole == UserRole.committee;

    final categories = ['All', 'Maintenance', 'Meetings', 'Events', 'General'];
    final filtered = _selectedCategory == 'All'
        ? _notices
        : _notices.where((n) => n.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Notices & Announcements', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (isPrivileged)
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF0F5C4D)),
              onPressed: _showCreateNoticeModal,
            ),
        ],
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
            // Category filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: const Color(0xFF0F5C4D),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.ink,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedCategory = cat);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 18),

            ...filtered.map((item) => _buildNoticeCard(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeCard(NoticeItem n) {
    Color badgeColor = Colors.blue;
    if (n.isUrgent) {
      badgeColor = Colors.red;
    } else if (n.category == 'Meetings') {
      badgeColor = Colors.purple;
    } else if (n.category == 'Events') {
      badgeColor = Colors.orange;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        n.isUrgent ? 'URGENT' : n.category.toUpperCase(),
                        style: TextStyle(
                          color: badgeColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      n.date,
                      style: const TextStyle(color: AppColors.mute, fontSize: 12),
                    ),
                  ],
                ),
                Text(
                  n.postedBy,
                  style: const TextStyle(color: AppColors.mute, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              n.title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 17,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              n.content,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            if (n.hasRsvp) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Meeting RSVP:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.ink)),
                  Row(
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: n.residentRsvpStatus == 'Cannot Attend' ? Colors.red : AppColors.mute,
                          side: BorderSide(color: n.residentRsvpStatus == 'Cannot Attend' ? Colors.red : Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onPressed: () {
                          setState(() => n.residentRsvpStatus = 'Cannot Attend');
                        },
                        child: const Text('Decline', style: TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: n.residentRsvpStatus == 'Attending' ? Colors.green : const Color(0xFF0F5C4D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        onPressed: () {
                          setState(() => n.residentRsvpStatus = 'Attending');
                        },
                        child: Row(
                          children: [
                            if (n.residentRsvpStatus == 'Attending') const Icon(Icons.check, size: 14),
                            if (n.residentRsvpStatus == 'Attending') const SizedBox(width: 4),
                            Text(n.residentRsvpStatus == 'Attending' ? 'Attending' : 'Attend', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
