import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/app_card.dart';

class VehicleItem {
  final String id;
  final String type; // '4-Wheeler' or '2-Wheeler'
  final String modelName;
  final String plateNumber;
  final String parkingSlot;
  final bool hasRfid;

  VehicleItem({
    required this.id,
    required this.type,
    required this.modelName,
    required this.plateNumber,
    required this.parkingSlot,
    this.hasRfid = true,
  });
}

/// Module 1: Auth & Profile - Vehicles & Parking Management
class VehiclesScreen extends ConsumerStatefulWidget {
  const VehiclesScreen({super.key});

  @override
  ConsumerState<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends ConsumerState<VehiclesScreen> {
  final List<VehicleItem> _vehicles = [
    VehicleItem(
      id: '1',
      type: '4-Wheeler',
      modelName: 'Hyundai Creta (White)',
      plateNumber: 'MH 12 AB 4589',
      parkingSlot: 'Basement 1 • Slot P-14',
      hasRfid: true,
    ),
    VehicleItem(
      id: '2',
      type: '2-Wheeler',
      modelName: 'Honda Activa 6G (Grey)',
      plateNumber: 'MH 12 CD 9012',
      parkingSlot: 'Ground • Slot B-08',
      hasRfid: true,
    ),
  ];

  void _showAddVehicleModal() {
    final modelCtrl = TextEditingController();
    final plateCtrl = TextEditingController();
    final slotCtrl = TextEditingController(text: 'P-');
    String selectedType = '4-Wheeler';

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
                        'Register New Vehicle',
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
                  DropdownButtonFormField<String>(
                    initialValue: selectedType,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Type',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    items: const [
                      DropdownMenuItem(value: '4-Wheeler', child: Text('4-Wheeler (Car / SUV)')),
                      DropdownMenuItem(value: '2-Wheeler', child: Text('2-Wheeler (Bike / Scooter)')),
                    ],
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedType = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: modelCtrl,
                    decoration: InputDecoration(
                      labelText: 'Brand & Model',
                      hintText: 'e.g. Maruti Swift or Royal Enfield',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: plateCtrl,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Registration Plate Number',
                      hintText: 'e.g. MH 12 AB 1234',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: slotCtrl,
                    decoration: InputDecoration(
                      labelText: 'Allotted Parking Slot',
                      hintText: 'e.g. Slot P-15',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F5C4D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        if (plateCtrl.text.trim().isNotEmpty) {
                          setState(() {
                            _vehicles.add(VehicleItem(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              type: selectedType,
                              modelName: modelCtrl.text.trim().isEmpty ? 'Private Vehicle' : modelCtrl.text.trim(),
                              plateNumber: plateCtrl.text.trim().toUpperCase(),
                              parkingSlot: slotCtrl.text.trim().isEmpty ? 'Slot Allotted by Admin' : slotCtrl.text.trim(),
                              hasRfid: true,
                            ));
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Vehicle registered! RFID boom barrier access activated.'),
                              backgroundColor: Color(0xFF0F5C4D),
                            ),
                          );
                        }
                      },
                      child: const Text('Register Vehicle', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
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
    final flat = user?.blockFlat ?? 'Tower B - 402';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('My Vehicles & Parking', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF0F5C4D)),
            onPressed: _showAddVehicleModal,
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
            // Boom barrier & RFID Status banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F5C4D), Color(0xFF167A66)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F5C4D).withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.nfc_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Flat $flat • RFID Tag Active',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Automatic Boom Barrier entry enabled for registered vehicles at Main Gate.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vehicles Registered (${_vehicles.length})',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.ink),
                ),
                TextButton.icon(
                  onPressed: _showAddVehicleModal,
                  icon: const Icon(Icons.add_rounded, size: 18, color: Color(0xFF0F5C4D)),
                  label: const Text('Add Vehicle', style: TextStyle(color: Color(0xFF0F5C4D), fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ..._vehicles.map((v) => _buildVehicleCard(v)),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(VehicleItem v) {
    final isCar = v.type == '4-Wheeler';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
                    color: (isCar ? Colors.blue : Colors.orange).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isCar ? Icons.directions_car_rounded : Icons.two_wheeler_rounded,
                    color: isCar ? Colors.blue : Colors.orange,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v.modelName,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ink),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        v.type,
                        style: const TextStyle(color: AppColors.mute, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check_circle_rounded, color: Colors.green, size: 14),
                      SizedBox(width: 4),
                      Text('RFID Active', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('License Plate', style: TextStyle(color: AppColors.mute, fontSize: 11)),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Text(
                        v.plateNumber,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.8),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Parking Allocation', style: TextStyle(color: AppColors.mute, fontSize: 11)),
                    const SizedBox(height: 3),
                    Text(
                      v.parkingSlot,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF0F5C4D)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
