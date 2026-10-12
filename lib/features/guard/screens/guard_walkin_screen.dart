import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

/// Module 7: Visitors & Gate - Guard Walk-in Visitor Registration
class GuardWalkinScreen extends StatefulWidget {
  const GuardWalkinScreen({super.key});

  @override
  State<GuardWalkinScreen> createState() => _GuardWalkinScreenState();
}

class _GuardWalkinScreenState extends State<GuardWalkinScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _vehicleController = TextEditingController();

  String _selectedTower = 'B';
  String _selectedFlat = '402';
  String _selectedPurpose = 'Delivery (Amazon/Swiggy)';
  bool _photoCaptured = false;
  bool _isSubmitting = false;

  final List<String> _purposes = [
    'Delivery (Amazon/Swiggy)',
    'Guest / Relative',
    'Cab / Taxi (Uber/Ola)',
    'Service & Repair / Plumber',
    'Vendor / Water Supply',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _vehicleController.dispose();
    super.dispose();
  }

  void _submitVisitorEntry() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter visitor full name'), backgroundColor: Colors.red),
      );
      return;
    }
    if (_phoneController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid 10-digit mobile number'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Entry Approved!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Visitor: ${_nameController.text.trim()}', style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('Destination: Tower $_selectedTower - $_selectedFlat'),
            const SizedBox(height: 4),
            Text('Purpose: $_selectedPurpose'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F4F1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Instant Push Notification & SMS sent to Resident for confirmation.',
                style: TextStyle(fontSize: 12, color: Color(0xFF0F5C4D)),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F5C4D),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            child: const Text('Complete & Open Gate'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Walk-in Visitor Entry', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visitor Photo Capture Card
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() => _photoCaptured = !_photoCaptured);
                },
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: _photoCaptured ? Colors.green.withValues(alpha: 0.1) : const Color(0xFFE6F4F1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _photoCaptured ? Colors.green : const Color(0xFF0F5C4D),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _photoCaptured ? Icons.check_circle_rounded : Icons.camera_alt_rounded,
                        color: _photoCaptured ? Colors.green : const Color(0xFF0F5C4D),
                        size: 34,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _photoCaptured ? 'Photo Added' : 'Take Photo',
                        style: TextStyle(
                          color: _photoCaptured ? Colors.green : const Color(0xFF0F5C4D),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Form Cards
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Visitor Details', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ink)),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Visitor Full Name',
                      hintText: 'e.g. Ramesh Kumar',
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Visitor Mobile Number',
                      hintText: '98765 43210',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedPurpose,
                    decoration: InputDecoration(
                      labelText: 'Purpose of Visit',
                      prefixIcon: const Icon(Icons.work_outline_rounded),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    items: _purposes.map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedPurpose = val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Destination Flat', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ink)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedTower,
                          decoration: InputDecoration(
                            labelText: 'Tower',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'A', child: Text('Tower A')),
                            DropdownMenuItem(value: 'B', child: Text('Tower B')),
                            DropdownMenuItem(value: 'C', child: Text('Tower C')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedTower = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedFlat,
                          decoration: InputDecoration(
                            labelText: 'Flat Number',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          items: const [
                            DropdownMenuItem(value: '101', child: Text('101')),
                            DropdownMenuItem(value: '102', child: Text('102')),
                            DropdownMenuItem(value: '201', child: Text('201')),
                            DropdownMenuItem(value: '402', child: Text('402')),
                            DropdownMenuItem(value: '501', child: Text('501')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedFlat = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _vehicleController,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Plate (Optional)',
                      hintText: 'e.g. MH 12 GH 9988',
                      prefixIcon: const Icon(Icons.directions_car_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5C4D),
                  disabledBackgroundColor: const Color(0xFF0F5C4D),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _isSubmitting ? null : _submitVisitorEntry,
                child: _isSubmitting
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                          SizedBox(width: 12),
                          Text('Generating Pass & Alerting Resident...', style: TextStyle(fontWeight: FontWeight.w700)),
                        ],
                      )
                    : const Text('Generate Gate Pass & Notify Resident', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
