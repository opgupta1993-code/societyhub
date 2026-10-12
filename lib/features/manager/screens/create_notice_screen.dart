import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';

/// Screen E5: Create Notice
/// PRD: Audience, attachment, push
class CreateNoticeScreen extends StatefulWidget {
  const CreateNoticeScreen({super.key});

  @override
  State<CreateNoticeScreen> createState() => _CreateNoticeScreenState();
}

class _CreateNoticeScreenState extends State<CreateNoticeScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'Maintenance';
  String _selectedAudience = 'All Society Residents';
  bool _sendPushNotification = true;
  bool _isUrgent = false;
  bool _enableRsvp = false;
  String? _attachedFileName;

  final List<String> _categories = [
    'Maintenance',
    'General',
    'Event',
    'Security',
    'Emergency',
  ];

  final List<String> _audiences = [
    'All Society Residents',
    'Tower A Residents Only',
    'Tower B Residents Only',
    'Tower C Residents Only',
    'Flat Owners Only',
    'Tenants Only',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _publishNotice() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a notice title and description'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notice "$title" published to $_selectedAudience! ${_sendPushNotification ? "Push notification sent." : ""}'),
        backgroundColor: const Color(0xFF0F5C4D),
        duration: const Duration(seconds: 3),
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F4),
      appBar: AppBar(
        title: const Text(
          'Create Society Notice (E5)',
          style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _publishNotice,
            child: const Text(
              'Publish',
              style: TextStyle(color: Color(0xFF0F5C4D), fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Notice Title
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Notice Headline *',
              hintText: 'e.g. Water Tank Cleaning & Supply Cut',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.line)),
            ),
          ),
          const SizedBox(height: 16),

          // Category Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.line),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedCategory,
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text('Category: $c'))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Target Audience Dropdown (PRD Requirement)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.line),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedAudience,
                items: _audiences.map((a) => DropdownMenuItem(value: a, child: Text('Audience: $a'))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedAudience = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Notice Description
          TextField(
            controller: _contentController,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: 'Notice Details & Description *',
              hintText: 'Provide complete details, timings, and contact points...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.line)),
            ),
          ),
          const SizedBox(height: 16),

          // Attachment Box (PRD Requirement)
          GestureDetector(
            onTap: () {
              setState(() {
                _attachedFileName = _attachedFileName == null ? 'Water_Supply_Notice_Circular.pdf' : null;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _attachedFileName != null ? const Color(0xFF0F5C4D) : AppColors.line),
              ),
              child: Row(
                children: [
                  Icon(
                    _attachedFileName != null ? Icons.attach_file_rounded : Icons.add_circle_outline_rounded,
                    color: _attachedFileName != null ? const Color(0xFF0F5C4D) : AppColors.mute,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _attachedFileName != null ? 'Attached: $_attachedFileName' : 'Add PDF / Image Attachment',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: _attachedFileName != null ? const Color(0xFF0F5C4D) : AppColors.ink,
                      ),
                    ),
                  ),
                  if (_attachedFileName != null)
                    const Icon(Icons.close_rounded, size: 18, color: Colors.red),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Options Toggles
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Send Instant Push Notification', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: const Text('Alert members immediately via app notification', style: TextStyle(fontSize: 12)),
                  value: _sendPushNotification,
                  activeThumbColor: const Color(0xFF0F5C4D),
                  onChanged: (val) => setState(() => _sendPushNotification = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Mark as High Priority / Urgent', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: const Text('Highlighted in red at the top of notice boards', style: TextStyle(fontSize: 12)),
                  value: _isUrgent,
                  activeThumbColor: Colors.red,
                  onChanged: (val) => setState(() => _isUrgent = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Enable Resident RSVP', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: const Text('Allow members to confirm attendance', style: TextStyle(fontSize: 12)),
                  value: _enableRsvp,
                  activeThumbColor: const Color(0xFF0F5C4D),
                  onChanged: (val) => setState(() => _enableRsvp = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Publish Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5C4D),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _publishNotice,
              icon: const Icon(Icons.campaign_rounded, size: 22),
              label: const Text('Publish & Broadcast Notice', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
