import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

/// Screen B3: Invite Visitor & Pre-approve Gate Pass (matches wireframe image exactly)
class InviteVisitorScreen extends ConsumerStatefulWidget {
  const InviteVisitorScreen({super.key});

  @override
  ConsumerState<InviteVisitorScreen> createState() => _InviteVisitorScreenState();
}

class _InviteVisitorScreenState extends ConsumerState<InviteVisitorScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _selectedDate = 'Today';
  String _selectedTimeSlot = '6–8 PM';
  String _selectedVisitorType = 'Guest';
  bool _repeatDaily = false;

  final List<String> _dateOptions = ['Today', 'Tomorrow', 'Oct 7, 2026', 'Oct 8, 2026'];
  final List<String> _timeOptions = [
    '8–11 AM',
    '12–3 PM',
    '4–6 PM',
    '6–8 PM',
    '8–11 PM',
    'Anytime',
  ];
  final List<String> _visitorTypes = ['Guest', 'Delivery', 'Cab', 'Service'];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleCreateGatePass() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the visitor name.'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.tint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.qr_code_2_rounded,
                  size: 72,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Gate Pass Created!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Pass for ${_nameController.text.trim()} ($_selectedVisitorType)\n$_selectedDate · $_selectedTimeSlot',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.mute, fontSize: 14),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366), // WhatsApp green
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gate Pass link shared via WhatsApp!')),
                    );
                    context.pop();
                  },
                  icon: const Icon(Icons.share_rounded, size: 20),
                  label: const Text(
                    'Share via WhatsApp',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.pop();
                },
                child: const Text('Done', style: TextStyle(color: AppColors.mute)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Invite visitor',
          style: text.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
            fontSize: 26,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // 1. Visitor Name Input Card
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: TextField(
                  controller: _nameController,
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Visitor name',
                    hintStyle: TextStyle(
                      color: AppColors.mute,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // 2. Mobile Number Input Card
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Mobile number',
                    hintStyle: TextStyle(
                      color: AppColors.mute,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // 3. Date & Time Slot Dropdown Row
              Row(
                children: [
                  // Date Dropdown
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedDate,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.mute),
                          style: text.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                            fontSize: 16,
                          ),
                          onChanged: (String? val) {
                            if (val != null) setState(() => _selectedDate = val);
                          },
                          items: _dateOptions.map((dateStr) {
                            return DropdownMenuItem(value: dateStr, child: Text(dateStr));
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Time Slot Dropdown
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedTimeSlot,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.mute),
                          style: text.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                            fontSize: 16,
                          ),
                          onChanged: (String? val) {
                            if (val != null) setState(() => _selectedTimeSlot = val);
                          },
                          items: _timeOptions.map((timeStr) {
                            return DropdownMenuItem(value: timeStr, child: Text(timeStr));
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 4. Visitor Type Segmented Pills (Guest, Delivery, Cab, Service)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _visitorTypes.map((type) => _buildTypePill(type)).toList(),
              ),
              const SizedBox(height: 20),

              // 5. Repeat Daily Toggle Card (maid, cook)
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Repeat daily (maid,\ncook)',
                        style: text.titleMedium?.copyWith(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          height: 1.3,
                        ),
                      ),
                    ),
                    Switch.adaptive(
                      value: _repeatDaily,
                      activeThumbColor: Colors.white,
                      activeTrackColor: AppColors.primary,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: AppColors.line,
                      onChanged: (val) {
                        setState(() => _repeatDaily = val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // 6. Create Gate Pass CTA Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: _handleCreateGatePass,
                  child: const Text('Create gate pass'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypePill(String title) {
    final isSelected = _selectedVisitorType == title;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedVisitorType = title);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.tint,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
