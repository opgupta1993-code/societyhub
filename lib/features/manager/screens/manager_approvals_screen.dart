import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class ManagerBookingRequest {
  final String id;
  final String amenityName;
  final String residentName;
  final String flat;
  final String date;
  final String timeSlot;
  final int guestCount;
  final double fee;
  String status; // 'pending', 'approved', 'rejected'

  ManagerBookingRequest({
    required this.id,
    required this.amenityName,
    required this.residentName,
    required this.flat,
    required this.date,
    required this.timeSlot,
    required this.guestCount,
    required this.fee,
    required this.status,
  });
}

/// Screen E4: Manager Booking Approvals
/// PRD: Approve or reject, slot calendar
class ManagerApprovalsScreen extends StatefulWidget {
  const ManagerApprovalsScreen({super.key});

  @override
  State<ManagerApprovalsScreen> createState() => _ManagerApprovalsScreenState();
}

class _ManagerApprovalsScreenState extends State<ManagerApprovalsScreen> {
  String _selectedFilter = 'All';

  final List<ManagerBookingRequest> _requests = [
    ManagerBookingRequest(
      id: 'BKG-801',
      amenityName: 'Clubhouse Banquet Hall',
      residentName: 'Rahul S.',
      flat: 'Tower B - 402',
      date: 'Sunday, 25 Oct 2026',
      timeSlot: '05:00 PM - 10:00 PM',
      guestCount: 35,
      fee: 2500,
      status: 'pending',
    ),
    ManagerBookingRequest(
      id: 'BKG-802',
      amenityName: 'Swimming Pool (Private Lane)',
      residentName: 'Megha Roy',
      flat: 'Tower C - 104',
      date: 'Saturday, 17 Oct 2026',
      timeSlot: '07:00 AM - 09:00 AM',
      guestCount: 4,
      fee: 400,
      status: 'pending',
    ),
    ManagerBookingRequest(
      id: 'BKG-803',
      amenityName: 'Tennis Court',
      residentName: 'Vikram Joshi',
      flat: 'Tower A - 302',
      date: 'Tomorrow, 14 Oct 2026',
      timeSlot: '06:00 AM - 08:00 AM',
      guestCount: 2,
      fee: 200,
      status: 'approved',
    ),
    ManagerBookingRequest(
      id: 'BKG-804',
      amenityName: 'Open Party Lawn',
      residentName: 'Sunita Mehra',
      flat: 'Tower A - 501',
      date: '20 Oct 2026',
      timeSlot: '06:00 PM - 11:00 PM',
      guestCount: 60,
      fee: 3500,
      status: 'rejected',
    ),
  ];

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking approvals updated'),
          backgroundColor: Color(0xFF0F5C4D),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _rejectBooking(ManagerBookingRequest req) {
    showDialog(
      context: context,
      builder: (ctx) {
        final reasonController = TextEditingController();
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Reject Booking Request', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Specify reason for rejecting booking #${req.id} for ${req.residentName}:', style: const TextStyle(fontSize: 13, color: AppColors.mute)),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  hintText: 'e.g. Slot already reserved for maintenance',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.mute)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () {
                setState(() => req.status = 'rejected');
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking #${req.id} rejected. Resident notified.'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Confirm Reject'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _requests.where((r) {
      if (_selectedFilter == 'Pending') return r.status == 'pending';
      if (_selectedFilter == 'Approved') return r.status == 'approved';
      if (_selectedFilter == 'Rejected') return r.status == 'rejected';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text(
          'Booking Approvals',
          style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xFF0F5C4D),
        onRefresh: _handleRefresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Pending', 'Approved', 'Rejected'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter, style: TextStyle(fontWeight: FontWeight.w700, color: isSelected ? Colors.white : AppColors.ink)),
                      selected: isSelected,
                      selectedColor: const Color(0xFF0F5C4D),
                      backgroundColor: Colors.white,
                      onSelected: (_) => setState(() => _selectedFilter = filter),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            if (filteredList.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: Text('No booking requests found')),
              )
            else
              ...filteredList.map((req) => _buildBookingCard(req)),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(ManagerBookingRequest req) {
    final isPending = req.status == 'pending';
    final isApproved = req.status == 'approved';

    return AppCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  req.amenityName,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ink),
                ),
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
                  req.status.toUpperCase(),
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
          Text(
            'Requested by: ${req.residentName} (${req.flat})',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.event_rounded, size: 14, color: AppColors.mute),
              const SizedBox(width: 4),
              Text(req.date, style: const TextStyle(fontSize: 12, color: AppColors.mute)),
              const SizedBox(width: 12),
              const Icon(Icons.access_time_rounded, size: 14, color: AppColors.mute),
              const SizedBox(width: 4),
              Text(req.timeSlot, style: const TextStyle(fontSize: 12, color: AppColors.mute)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Guests: ${req.guestCount} · Fee: ₹${req.fee.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 12, color: AppColors.mute),
          ),
          const SizedBox(height: 14),

          if (isPending)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _rejectBooking(req),
                    child: const Text('Reject', style: TextStyle(fontWeight: FontWeight.w800)),
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
                          content: Text('Booking #${req.id} approved for ${req.residentName}!'),
                          backgroundColor: const Color(0xFF0F5C4D),
                        ),
                      );
                    },
                    child: const Text('Approve Slot', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            )
          else
            Text(
              isApproved ? '✓ Slot confirmed on master society calendar' : '✕ Request rejected',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isApproved ? const Color(0xFF0F5C4D) : Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
