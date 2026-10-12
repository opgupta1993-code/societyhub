import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class VehicleLookupItem {
  final String plateNumber;
  final String ownerName;
  final String flat;
  final String slot;
  final bool isAuthorized;
  final String vehicleType;

  VehicleLookupItem({
    required this.plateNumber,
    required this.ownerName,
    required this.flat,
    required this.slot,
    required this.isAuthorized,
    required this.vehicleType,
  });
}

class SocietyStaffItem {
  final String id;
  final String name;
  final String role;
  final String phone;
  final List<String> allottedFlats;
  final bool isValidPass;
  bool isInside;
  String lastTime;

  SocietyStaffItem({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.allottedFlats,
    required this.isValidPass,
    required this.isInside,
    required this.lastTime,
  });
}

/// Screen H5: Staff & Vehicle Check
/// PRD: Valid or not, emergency alert
class GuardStaffCheckScreen extends StatefulWidget {
  const GuardStaffCheckScreen({super.key});

  @override
  State<GuardStaffCheckScreen> createState() => _GuardStaffCheckScreenState();
}

class _GuardStaffCheckScreenState extends State<GuardStaffCheckScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _vehicleSearchController = TextEditingController();

  final List<VehicleLookupItem> _registeredVehicles = [
    VehicleLookupItem(
      plateNumber: 'DL 01 AB 1234',
      ownerName: 'Rahul S.',
      flat: 'Tower B - 402',
      slot: 'P-24 (Basement 1)',
      isAuthorized: true,
      vehicleType: 'Car (Honda City)',
    ),
    VehicleLookupItem(
      plateNumber: 'UP 16 Z 9821',
      ownerName: 'Sunil Mehta',
      flat: 'Tower A - 101',
      slot: 'P-08 (Basement 1)',
      isAuthorized: true,
      vehicleType: 'Car (Hyundai Creta)',
    ),
    VehicleLookupItem(
      plateNumber: 'HR 26 DQ 4411',
      ownerName: 'Pooja Verma',
      flat: 'Tower C - 204',
      slot: 'P-45 (Open Stilt)',
      isAuthorized: true,
      vehicleType: 'EV Scooter (Ather 450)',
    ),
    VehicleLookupItem(
      plateNumber: 'DL 04 CE 9900',
      ownerName: 'Commercial Delivery',
      flat: 'Temporary Visitor',
      slot: 'Visitor Parking V-02',
      isAuthorized: false,
      vehicleType: 'Van (Amazon Logistics)',
    ),
  ];

  final List<SocietyStaffItem> _dailyStaff = [
    SocietyStaffItem(
      id: 'STF-01',
      name: 'Sunita Devi',
      role: 'Housekeeping / Maid',
      phone: '+91 98765 00011',
      allottedFlats: ['B-402', 'B-405', 'C-102'],
      isValidPass: true,
      isInside: true,
      lastTime: 'In at 07:15 AM',
    ),
    SocietyStaffItem(
      id: 'STF-02',
      name: 'Ramesh Kumar',
      role: 'Society Plumber',
      phone: '+91 98765 00022',
      allottedFlats: ['All Towers'],
      isValidPass: true,
      isInside: true,
      lastTime: 'In at 08:30 AM',
    ),
    SocietyStaffItem(
      id: 'STF-03',
      name: 'Mohan Lal',
      role: 'Private Driver',
      phone: '+91 98765 00033',
      allottedFlats: ['A-101'],
      isValidPass: true,
      isInside: false,
      lastTime: 'Out at 01:20 PM',
    ),
    SocietyStaffItem(
      id: 'STF-04',
      name: 'Kamla Bai',
      role: 'Cook',
      phone: '+91 98765 00044',
      allottedFlats: ['B-402', 'A-301'],
      isValidPass: false,
      isInside: false,
      lastTime: 'Pass Expired 10 Oct',
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
    _vehicleSearchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gate Check records updated'),
          backgroundColor: Color(0xFF0F5C4D),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _triggerEmergencyAlert() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text('EMERGENCY SOS', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.red, fontSize: 18)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Broadcast emergency alarm to estate manager, security control room, and all society residents?',
                style: TextStyle(fontSize: 13, color: AppColors.ink, height: 1.4),
              ),
              SizedBox(height: 14),
              Text('Select Emergency Category:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.mute)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🚨 SOS ALERT BROADCASTED: ESTATE POLICE & MANAGER NOTIFIED'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              child: const Text('BROADCAST SOS', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _vehicleSearchController.text.trim().toLowerCase();
    final filteredVehicles = _registeredVehicles.where((v) {
      if (query.isEmpty) return true;
      return v.plateNumber.toLowerCase().contains(query) ||
          v.ownerName.toLowerCase().contains(query) ||
          v.flat.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F4),
      appBar: AppBar(
        title: const Text(
          'Staff & Vehicle Check (H5)',
          style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            tooltip: 'Emergency SOS Alert',
            icon: const Icon(Icons.emergency_share_rounded, color: Colors.red),
            onPressed: _triggerEmergencyAlert,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF0F5C4D),
          labelColor: const Color(0xFF0F5C4D),
          unselectedLabelColor: AppColors.mute,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          tabs: const [
            Tab(text: 'Vehicle Plate Check'),
            Tab(text: 'Staff Attendance'),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xFF0F5C4D),
        onRefresh: _handleRefresh,
        child: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Vehicle Plate Lookup
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Red SOS Header Banner
                GestureDetector(
                  onTap: _triggerEmergencyAlert,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          child: const Icon(Icons.emergency_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Society Emergency SOS Trigger',
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900, fontSize: 13),
                              ),
                              Text(
                                'Tap in case of fire, unauthorized intrusion, or medical crisis',
                                style: TextStyle(fontSize: 11, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, color: Colors.red, size: 14),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Vehicle Search Bar
                TextField(
                  controller: _vehicleSearchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                    hintText: 'Search Plate Number (e.g. DL 01 AB)',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.line),
                    ),
                    suffixIcon: _vehicleSearchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _vehicleSearchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),

                const Text('Registered Vehicles & Parking Slots', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.ink)),
                const SizedBox(height: 10),

                ...filteredVehicles.map((v) => _buildVehicleCard(v)),
              ],
            ),

            // Tab 2: Daily Staff Attendance
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Regular Society Staff', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.ink)),
                    Text(
                      '${_dailyStaff.where((s) => s.isInside).length} Inside Society',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF0F5C4D)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ..._dailyStaff.map((s) => _buildStaffCard(s)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(VehicleLookupItem item) {
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
                item.plateNumber,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.ink, letterSpacing: 0.5),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: item.isAuthorized ? const Color(0xFFE6F4F1) : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.isAuthorized ? Icons.check_circle_rounded : Icons.warning_rounded,
                      size: 14,
                      color: item.isAuthorized ? const Color(0xFF0F5C4D) : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.isAuthorized ? 'AUTHORIZED' : 'UNVERIFIED',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: item.isAuthorized ? const Color(0xFF0F5C4D) : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('${item.vehicleType} · ${item.ownerName}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.apartment_rounded, size: 14, color: AppColors.mute),
              const SizedBox(width: 4),
              Text(item.flat, style: const TextStyle(fontSize: 12, color: AppColors.mute)),
              const SizedBox(width: 12),
              const Icon(Icons.local_parking_rounded, size: 14, color: AppColors.mute),
              const SizedBox(width: 4),
              Text(item.slot, style: const TextStyle(fontSize: 12, color: AppColors.mute)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: item.isAuthorized ? const Color(0xFF0F5C4D) : const Color(0xFF0062E0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gate entry logged for vehicle: ${item.plateNumber} (${item.flat})'),
                    backgroundColor: const Color(0xFF0F5C4D),
                  ),
                );
              },
              icon: const Icon(Icons.login_rounded, size: 16),
              label: Text(
                item.isAuthorized ? 'Grant Boom Barrier Entry' : 'Log As Visitor Vehicle',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffCard(SocietyStaffItem item) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFE6F4F1),
            child: Text(
              item.name.isNotEmpty ? item.name[0] : 'S',
              style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0F5C4D), fontSize: 18),
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
                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.ink)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: item.isValidPass ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.isValidPass ? 'Valid Pass' : 'Pass Expired',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: item.isValidPass ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text('${item.role} · ${item.phone}', style: const TextStyle(fontSize: 12, color: AppColors.mute)),
                const SizedBox(height: 4),
                Text('Works at: ${item.allottedFlats.join(", ")}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: AppColors.ink)),
                const SizedBox(height: 6),
                Text(item.lastTime, style: const TextStyle(fontSize: 11, color: AppColors.mute)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: item.isInside ? Colors.red : const Color(0xFF0F5C4D),
                          side: BorderSide(color: item.isInside ? Colors.red : const Color(0xFF0F5C4D)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onPressed: () {
                          setState(() {
                            item.isInside = !item.isInside;
                            item.lastTime = item.isInside ? 'In at Just Now' : 'Out at Just Now';
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.name} marked ${item.isInside ? "INSIDE" : "EXITED"}'),
                              backgroundColor: const Color(0xFF0F5C4D),
                            ),
                          );
                        },
                        child: Text(
                          item.isInside ? 'Mark Exit' : 'Mark Entry',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
