import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class Amenity {
  final String id;
  final String name;
  final String timing;
  final String feeText;
  final int feeAmount;
  final IconData icon;
  final String rules;

  const Amenity({
    required this.id,
    required this.name,
    required this.timing,
    required this.feeText,
    required this.feeAmount,
    required this.icon,
    required this.rules,
  });
}

class BookingRecord {
  final String id;
  final String amenityName;
  final String date;
  final String slot;
  final String status; // 'Approved', 'Pending Approval', 'Cancelled'
  final int fee;

  BookingRecord({
    required this.id,
    required this.amenityName,
    required this.date,
    required this.slot,
    required this.status,
    required this.fee,
  });
}

/// Module 9: Amenities - Amenity Booking & Approvals
class AmenityBookingScreen extends ConsumerStatefulWidget {
  const AmenityBookingScreen({super.key});

  @override
  ConsumerState<AmenityBookingScreen> createState() => _AmenityBookingScreenState();
}

class _AmenityBookingScreenState extends ConsumerState<AmenityBookingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Amenity> _amenities = const [
    Amenity(
      id: '1',
      name: 'Clubhouse Banquet Hall',
      timing: '6:00 PM – 11:00 PM',
      feeText: '₹ 2,500 / event',
      feeAmount: 2500,
      icon: Icons.celebration_rounded,
      rules: 'Cleaning deposit refundable. Max 100 guests permitted.',
    ),
    Amenity(
      id: '2',
      name: 'Swimming Pool & Deck',
      timing: '6:00 AM – 9:00 PM',
      feeText: 'Free (Resident Pass)',
      feeAmount: 0,
      icon: Icons.pool_rounded,
      rules: 'Proper swimwear mandatory. Tuesday closed for chemical cleaning.',
    ),
    Amenity(
      id: '3',
      name: 'Badminton Court (Indoor)',
      timing: '6:00 AM – 10:00 PM',
      feeText: '₹ 100 / hour',
      feeAmount: 100,
      icon: Icons.sports_tennis_rounded,
      rules: 'Non-marking gum shoes required. Max 2 slots per flat per day.',
    ),
    Amenity(
      id: '4',
      name: 'Central Party Lawn & Gazebo',
      timing: '5:00 PM – 10:30 PM',
      feeText: '₹ 3,500 / event',
      feeAmount: 3500,
      icon: Icons.deck_rounded,
      rules: 'No loud music after 10:00 PM as per society norms.',
    ),
  ];

  final List<BookingRecord> _myBookings = [
    BookingRecord(
      id: 'BKG-101',
      amenityName: 'Badminton Court (Indoor)',
      date: 'Tomorrow, 14 Oct',
      slot: '07:00 AM – 08:00 AM',
      status: 'Approved',
      fee: 100,
    ),
    BookingRecord(
      id: 'BKG-102',
      amenityName: 'Clubhouse Banquet Hall',
      date: '28 Oct 2026',
      slot: '06:00 PM – 11:00 PM',
      status: 'Pending Approval',
      fee: 2500,
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

  void _showBookAmenitySheet(Amenity amenity) {
    String selectedSlot = 'Morning: 7:00 AM - 8:00 AM';
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
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
                      Text(
                        amenity.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F4F1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Booking Fee:', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F5C4D))),
                        Text(amenity.feeText, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0F5C4D))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Select Date', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (picked != null) {
                        setSheetState(() => selectedDate = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}', style: const TextStyle(fontWeight: FontWeight.w700)),
                          const Icon(Icons.calendar_month_rounded, color: Color(0xFF0F5C4D)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Select Slot', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: selectedSlot,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Morning: 7:00 AM - 8:00 AM', child: Text('Morning: 7:00 AM - 8:00 AM')),
                      DropdownMenuItem(value: 'Morning: 8:00 AM - 9:00 AM', child: Text('Morning: 8:00 AM - 9:00 AM')),
                      DropdownMenuItem(value: 'Evening: 5:00 PM - 6:00 PM', child: Text('Evening: 5:00 PM - 6:00 PM')),
                      DropdownMenuItem(value: 'Evening: 6:00 PM - 11:00 PM', child: Text('Evening: 6:00 PM - 11:00 PM')),
                    ],
                    onChanged: (val) {
                      if (val != null) setSheetState(() => selectedSlot = val);
                    },
                  ),
                  const SizedBox(height: 20),
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
                        setState(() {
                          _myBookings.insert(
                            0,
                            BookingRecord(
                              id: 'BKG-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                              amenityName: amenity.name,
                              date: '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                              slot: selectedSlot,
                              status: amenity.feeAmount > 0 ? 'Pending Approval' : 'Approved',
                              fee: amenity.feeAmount,
                            ),
                          );
                        });
                        Navigator.pop(ctx);
                        _tabController.animateTo(1);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${amenity.name} booked successfully!'),
                            backgroundColor: const Color(0xFF0F5C4D),
                          ),
                        );
                      },
                      child: const Text('Confirm & Book Slot', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Amenities & Booking', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
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
          tabs: const [
            Tab(text: 'Book Amenity'),
            Tab(text: 'My Bookings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Catalog
          RefreshIndicator(
            color: const Color(0xFF0F5C4D),
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 600));
              if (mounted) setState(() {});
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ..._amenities.map((amenity) => _buildAmenityCard(amenity)),
              ],
            ),
          ),

          // Tab 2: My Bookings
          RefreshIndicator(
            color: const Color(0xFF0F5C4D),
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 600));
              if (mounted) setState(() {});
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (_myBookings.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text('No active bookings found.', style: TextStyle(color: AppColors.mute)),
                    ),
                  )
                else
                  ..._myBookings.map((b) => _buildBookingCard(b)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityCard(Amenity a) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F5C4D).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(a.icon, color: const Color(0xFF0F5C4D), size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ink)),
                      const SizedBox(height: 2),
                      Text(a.timing, style: const TextStyle(color: AppColors.mute, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: a.feeAmount == 0 ? Colors.green.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    a.feeAmount == 0 ? 'FREE' : a.feeText,
                    style: TextStyle(
                      color: a.feeAmount == 0 ? Colors.green : Colors.blue,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              a.rules,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5C4D),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _showBookAmenitySheet(a),
                child: const Text('Book Slot Now', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(BookingRecord b) {
    Color statusColor = Colors.green;
    if (b.status == 'Pending Approval') {
      statusColor = Colors.orange;
    } else if (b.status == 'Cancelled') {
      statusColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(b.id, style: const TextStyle(color: AppColors.mute, fontSize: 11, fontWeight: FontWeight.w600)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    b.status,
                    style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(b.amenityName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.ink)),
            const SizedBox(height: 4),
            Text('${b.date} • ${b.slot}', style: const TextStyle(color: Colors.black87, fontSize: 13)),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fee: ${b.fee == 0 ? "Free" : "₹${b.fee}"}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                if (b.status != 'Cancelled')
                  TextButton(
                    onPressed: () {
                      setState(() {
                        final idx = _myBookings.indexWhere((item) => item.id == b.id);
                        if (idx != -1) {
                          _myBookings[idx] = BookingRecord(
                            id: b.id,
                            amenityName: b.amenityName,
                            date: b.date,
                            slot: b.slot,
                            status: 'Cancelled',
                            fee: b.fee,
                          );
                        }
                      });
                    },
                    child: const Text('Cancel Booking', style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
