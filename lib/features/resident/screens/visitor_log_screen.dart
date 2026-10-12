import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class VisitorLogEntry {
  final String id;
  final String visitorName;
  final String phone;
  final String destinationFlat;
  final String purpose;
  final String entryTime;
  String? exitTime;
  final bool isInside;

  VisitorLogEntry({
    required this.id,
    required this.visitorName,
    required this.phone,
    required this.destinationFlat,
    required this.purpose,
    required this.entryTime,
    this.exitTime,
    this.isInside = true,
  });
}

/// Screen B4 / H4: Visitor In/Out Logbook
class VisitorLogScreen extends StatefulWidget {
  const VisitorLogScreen({super.key});

  @override
  State<VisitorLogScreen> createState() => _VisitorLogScreenState();
}

class _VisitorLogScreenState extends State<VisitorLogScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<VisitorLogEntry> _logs = [
    VisitorLogEntry(
      id: 'VIS-901',
      visitorName: 'Amazon Courier (Suresh)',
      phone: '+91 98111 44551',
      destinationFlat: 'Tower B - 402',
      purpose: 'Package Delivery',
      entryTime: 'Today, 02:45 PM',
      isInside: true,
    ),
    VisitorLogEntry(
      id: 'VIS-902',
      visitorName: 'Deepak Varma (Guest)',
      phone: '+91 98222 55662',
      destinationFlat: 'Tower B - 402',
      purpose: 'Personal Guest',
      entryTime: 'Today, 11:30 AM',
      isInside: true,
    ),
    VisitorLogEntry(
      id: 'VIS-903',
      visitorName: 'Swiggy Delivery',
      phone: '+91 98333 66773',
      destinationFlat: 'Tower B - 402',
      purpose: 'Food Delivery',
      entryTime: 'Yesterday, 08:15 PM',
      exitTime: 'Yesterday, 08:35 PM',
      isInside: false,
    ),
    VisitorLogEntry(
      id: 'VIS-904',
      visitorName: 'Urban Company AC Technician',
      phone: '+91 98444 77884',
      destinationFlat: 'Tower B - 402',
      purpose: 'AC Servicing',
      entryTime: '10 Oct, 03:00 PM',
      exitTime: '10 Oct, 04:45 PM',
      isInside: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeVisitors = _logs.where((l) => l.isInside).toList();
    final pastVisitors = _logs.where((l) => !l.isInside).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Visitor Logbook (B4/H4)', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF0F5C4D),
          unselectedLabelColor: AppColors.mute,
          indicatorColor: const Color(0xFF0F5C4D),
          indicatorWeight: 3,
          tabs: [
            Tab(text: 'Currently Inside (${activeVisitors.length})'),
            Tab(text: 'Past Entries (${pastVisitors.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Currently Inside Tab
          RefreshIndicator(
            color: const Color(0xFF0F5C4D),
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 600));
              if (mounted) setState(() {});
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (activeVisitors.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text('No visitors currently inside.', style: TextStyle(color: AppColors.mute)),
                    ),
                  )
                else
                  ...activeVisitors.map((entry) => _buildEntryCard(entry)),
              ],
            ),
          ),

          // Past Entries Tab
          RefreshIndicator(
            color: const Color(0xFF0F5C4D),
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 600));
              if (mounted) setState(() {});
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ...pastVisitors.map((entry) => _buildEntryCard(entry)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryCard(VisitorLogEntry e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (e.isInside ? Colors.amber : Colors.green).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        e.isInside ? Icons.login_rounded : Icons.logout_rounded,
                        color: e.isInside ? Colors.amber.shade900 : Colors.green,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.visitorName,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.ink),
                        ),
                        Text(
                          '${e.purpose} • ${e.destinationFlat}',
                          style: const TextStyle(color: AppColors.mute, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (e.isInside ? Colors.orange : Colors.grey).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    e.isInside ? 'Inside' : 'Departed',
                    style: TextStyle(
                      color: e.isInside ? Colors.orange.shade800 : Colors.grey.shade700,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Entry: ${e.entryTime}', style: const TextStyle(color: AppColors.mute, fontSize: 11)),
                    if (e.exitTime != null)
                      Text('Exit: ${e.exitTime}', style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
                if (e.isInside)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F5C4D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      setState(() {
                        final idx = _logs.indexWhere((item) => item.id == e.id);
                        if (idx != -1) {
                          _logs[idx] = VisitorLogEntry(
                            id: e.id,
                            visitorName: e.visitorName,
                            phone: e.phone,
                            destinationFlat: e.destinationFlat,
                            purpose: e.purpose,
                            entryTime: e.entryTime,
                            exitTime: 'Just now',
                            isInside: false,
                          );
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${e.visitorName} marked as departed!'), backgroundColor: Colors.green),
                      );
                    },
                    child: const Text('Mark Exit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
