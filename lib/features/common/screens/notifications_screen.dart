import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final String category; // Bills, Visitors, Complaints, Polls
  final IconData icon;
  final Color color;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.category,
    required this.icon,
    required this.color,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedCategory = 'All';

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'n1',
      title: 'Visitor Gate Approval (B4)',
      message: 'Delivery Executive Rohan is at Main Gate requesting entry.',
      time: '5 mins ago',
      category: 'Visitors',
      icon: Icons.shield_outlined,
      color: Colors.blue,
    ),
    NotificationItem(
      id: 'n2',
      title: 'Monthly Maintenance Bill (B1/F2)',
      message: 'Bill for October 2026 generated. Total amount ₹2,450. Due on 15th Oct.',
      time: '2 hours ago',
      category: 'Bills',
      icon: Icons.receipt_long_outlined,
      color: Colors.green,
    ),
    NotificationItem(
      id: 'n3',
      title: 'Complaint Status Update (B2/E3)',
      message: 'Plumbing Complaint #CMP-104 assigned to Staff Ramesh. ETA: 4:00 PM.',
      time: '1 day ago',
      category: 'Complaints',
      icon: Icons.build_circle_outlined,
      color: Colors.orange,
    ),
    NotificationItem(
      id: 'n4',
      title: 'New Community Poll (B6/G2)',
      message: 'Committee published a new poll: "EV Charging Station Installation in B Wing".',
      time: '2 days ago',
      category: 'Polls',
      icon: Icons.poll_outlined,
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredList = _selectedCategory == 'All'
        ? _notifications
        : _notifications.where((n) => n.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications (A4)'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read')),
              );
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: ['All', 'Bills', 'Visitors', 'Complaints', 'Polls'].map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    selectedColor: AppColors.primary.withValues(alpha: 0.2),
                    checkmarkColor: AppColors.primary,
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(),

          // Notification List
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Text(
                      'No notifications in this category',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredList.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: item.color.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(item.icon, color: item.color, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        item.time,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.message,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
