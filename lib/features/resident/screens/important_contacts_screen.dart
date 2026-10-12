import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class ContactItem {
  final String title;
  final String subtitle;
  final String phone;
  final IconData icon;
  final Color color;
  final bool isEmergency;

  const ContactItem({
    required this.title,
    required this.subtitle,
    required this.phone,
    required this.icon,
    required this.color,
    this.isEmergency = false,
  });
}

/// Module 10: Directory & Documents - Important & Emergency Contacts
class ImportantContactsScreen extends StatelessWidget {
  const ImportantContactsScreen({super.key});

  final List<ContactItem> _contacts = const [
    ContactItem(
      title: 'Main Security Gate',
      subtitle: 'Guard Desk • 24/7 Available',
      phone: '020-2748-0001',
      icon: Icons.security_rounded,
      color: Color(0xFF0F5C4D),
      isEmergency: false,
    ),
    ContactItem(
      title: 'Society Management Office',
      subtitle: 'Manager Desk • 9 AM - 6 PM',
      phone: '020-2748-0002',
      icon: Icons.apartment_rounded,
      color: Colors.blue,
      isEmergency: false,
    ),
    ContactItem(
      title: 'Society Plumber (Ramesh)',
      subtitle: 'Available: 9 AM - 7 PM',
      phone: '+91 98220 33441',
      icon: Icons.plumbing_rounded,
      color: Colors.teal,
      isEmergency: false,
    ),
    ContactItem(
      title: 'Society Electrician (Sunil)',
      subtitle: 'Available: 9 AM - 8 PM',
      phone: '+91 98220 33442',
      icon: Icons.electric_bolt_rounded,
      color: Colors.amber,
      isEmergency: false,
    ),
    ContactItem(
      title: 'Schindler Lift Emergency SOS',
      subtitle: '24/7 Lift Breakdown Assistance',
      phone: '1800-200-5438',
      icon: Icons.elevator_rounded,
      color: Colors.deepOrange,
      isEmergency: true,
    ),
    ContactItem(
      title: 'Local Police Station (Kothrud)',
      subtitle: 'Emergency Help',
      phone: '112 / 020-2544-0100',
      icon: Icons.local_police_rounded,
      color: Colors.red,
      isEmergency: true,
    ),
    ContactItem(
      title: 'Ambulance & Medical Emergency',
      subtitle: 'Ruby Hall Clinic Satellite Desk',
      phone: '108 / 020-6645-5555',
      icon: Icons.emergency_rounded,
      color: Colors.redAccent,
      isEmergency: true,
    ),
    ContactItem(
      title: 'Fire Brigade Station',
      subtitle: 'City Fire Control',
      phone: '101',
      icon: Icons.fire_truck_rounded,
      color: Colors.red,
      isEmergency: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Important Contacts', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Emergency Header Alert Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: const [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'In case of fire, medical, or lift emergency, tap the call button directly for immediate response.',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          ..._contacts.map((c) => _buildContactCard(context, c)),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, ContactItem c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: c.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(c.icon, color: c.color, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.title,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.ink),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    c.subtitle,
                    style: const TextStyle(color: AppColors.mute, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    c.phone,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: c.isEmergency ? Colors.red : const Color(0xFF0F5C4D),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.phone_forwarded_rounded, color: Colors.green, size: 26),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Calling ${c.title} (${c.phone})...'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
