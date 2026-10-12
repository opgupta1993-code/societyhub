import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class GateApprovalItem {
  final String id;
  final String visitorName;
  final String visitorPhone;
  final String flat;
  final String residentName;
  final String purpose;
  final String requestTime;
  String status; // 'pending', 'approved', 'denied'

  GateApprovalItem({
    required this.id,
    required this.visitorName,
    required this.visitorPhone,
    required this.flat,
    required this.residentName,
    required this.purpose,
    required this.requestTime,
    required this.status,
  });
}

/// Screen H3: Approval Status
/// PRD: Resident approve or deny live monitor
class GuardApprovalStatusScreen extends StatefulWidget {
  const GuardApprovalStatusScreen({super.key});

  @override
  State<GuardApprovalStatusScreen> createState() => _GuardApprovalStatusScreenState();
}

class _GuardApprovalStatusScreenState extends State<GuardApprovalStatusScreen> {
  final List<GateApprovalItem> _requests = [
    GateApprovalItem(
      id: 'REQ-401',
      visitorName: 'Swiggy Food Delivery (Rohan)',
      visitorPhone: '+91 98111 22334',
      flat: 'Tower B - 402',
      residentName: 'Rahul S.',
      purpose: 'Food Delivery',
      requestTime: '1 min ago',
      status: 'pending',
    ),
    GateApprovalItem(
      id: 'REQ-402',
      visitorName: 'Deepak Varma (Guest)',
      visitorPhone: '+91 98222 33445',
      flat: 'Tower B - 402',
      residentName: 'Rahul S.',
      purpose: 'Guest Visit',
      requestTime: '3 mins ago',
      status: 'approved',
    ),
    GateApprovalItem(
      id: 'REQ-403',
      visitorName: 'Urban Company AC Technician',
      visitorPhone: '+91 98333 44556',
      flat: 'Tower A - 101',
      residentName: 'Sunil Mehta',
      purpose: 'Appliance Repair',
      requestTime: '12 mins ago',
      status: 'denied',
    ),
    GateApprovalItem(
      id: 'REQ-404',
      visitorName: 'Zomato Delivery Boy',
      visitorPhone: '+91 98444 55667',
      flat: 'Tower C - 304',
      residentName: 'Priya Nair',
      purpose: 'Food Delivery',
      requestTime: '18 mins ago',
      status: 'approved',
    ),
  ];

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gate approval requests updated'),
          backgroundColor: Color(0xFF0F5C4D),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _requests.where((r) => r.status == 'pending').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F4),
      appBar: AppBar(
        title: const Text(
          'Live Approval Status (H3)',
          style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: pendingCount > 0 ? Colors.amber.shade100 : const Color(0xFFE6F4F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sensors_rounded,
                  size: 14,
                  color: pendingCount > 0 ? Colors.amber.shade900 : const Color(0xFF0F5C4D),
                ),
                const SizedBox(width: 4),
                Text(
                  '$pendingCount Pending',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: pendingCount > 0 ? Colors.amber.shade900 : const Color(0xFF0F5C4D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF0F5C4D),
        onRefresh: _handleRefresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Status explanation banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F4F1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline_rounded, color: Color(0xFF0F5C4D), size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Live gate notifications sent to resident phones. Status reflects in real time when resident taps Allow or Deny.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF0F5C4D), height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            ..._requests.map((req) => _buildRequestCard(req)),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(GateApprovalItem req) {
    final isPending = req.status == 'pending';
    final isApproved = req.status == 'approved';

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                req.visitorName,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.ink),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPending
                      ? Colors.amber.shade50
                      : isApproved
                          ? const Color(0xFFE6F4F1)
                          : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isPending
                      ? 'WAITING RESIDENT'
                      : isApproved
                          ? 'APPROVED'
                          : 'DENIED',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: isPending
                        ? Colors.amber.shade900
                        : isApproved
                            ? const Color(0xFF0F5C4D)
                            : Colors.red.shade900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.apartment_rounded, size: 14, color: AppColors.mute),
              const SizedBox(width: 4),
              Text('${req.flat} (${req.residentName})', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.ink)),
              const SizedBox(width: 12),
              const Icon(Icons.access_time_rounded, size: 14, color: AppColors.mute),
              const SizedBox(width: 4),
              Text(req.requestTime, style: const TextStyle(fontSize: 12, color: AppColors.mute)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Purpose: ${req.purpose} · Phone: ${req.visitorPhone}', style: const TextStyle(fontSize: 12, color: AppColors.mute)),
          const SizedBox(height: 12),

          if (isPending)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0062E0),
                      side: const BorderSide(color: Color(0xFF0062E0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Calling intercom for ${req.flat}...'),
                          backgroundColor: const Color(0xFF0062E0),
                        ),
                      );
                    },
                    icon: const Icon(Icons.phone_in_talk_rounded, size: 16),
                    label: const Text('Call Flat', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F5C4D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      setState(() => req.status = 'approved');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gate entry approved for ${req.visitorName}!'),
                          backgroundColor: const Color(0xFF0F5C4D),
                        ),
                      );
                    },
                    child: const Text('Simulate Allow', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                  ),
                ),
              ],
            )
          else if (isApproved)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5C4D),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Pass printed & gate opened for ${req.visitorName}!'),
                      backgroundColor: const Color(0xFF0F5C4D),
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle_rounded, size: 16),
                label: const Text('Print Pass & Open Gate Barrier', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.block_rounded, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Resident refused entry. Do NOT allow beyond gate.', style: TextStyle(color: Colors.red, fontSize: 11.5, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
