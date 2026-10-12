import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

/// Screen B14: Help & Support (Contact Society Office, FAQs, Ticketing)
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Help & Support (B14)', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
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
          // Helpdesk Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F5C4D), Color(0xFF167A66)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                  child: const Icon(Icons.support_agent_rounded, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Society Help Desk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
                      SizedBox(height: 4),
                      Text('We are here to assist with billing, complaints, gates, or amenities.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Contact Options
          const Text('Direct Contacts', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ink)),
          const SizedBox(height: 12),

          _buildHelpTile(
            context,
            icon: Icons.phone_in_talk_rounded,
            title: 'Call Society Office',
            subtitle: 'Mon - Sat: 9:00 AM – 6:00 PM',
            actionText: 'Call Office',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calling Society Office (020-2748-0002)...'), backgroundColor: Colors.green),
              );
            },
          ),
          const SizedBox(height: 10),

          _buildHelpTile(
            context,
            icon: Icons.chat_rounded,
            title: 'WhatsApp Society Helpdesk',
            subtitle: 'Instant automated support & updates',
            actionText: 'Chat Now',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening WhatsApp Helpdesk...'), backgroundColor: Color(0xFF0F5C4D)),
              );
            },
          ),
          const SizedBox(height: 10),

          _buildHelpTile(
            context,
            icon: Icons.build_rounded,
            title: 'Raise an Issue / Ticket',
            subtitle: 'Plumbing, lift, electricity or common area issue',
            actionText: 'Raise Ticket',
            onTap: () => context.push('/complaints'),
          ),

          const SizedBox(height: 24),
          const Text('Frequently Asked Questions', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ink)),
          const SizedBox(height: 12),

          _buildFaqItem('How do I invite a guest or generate a QR gate pass?', 'Go to the Visitors section on your home dashboard, enter the guest name, and tap "Generate Pass". You can share the pass via WhatsApp.'),
          _buildFaqItem('How can I pay my monthly maintenance dues?', 'Tap on "Pay Dues" on your home screen or billing tab. You can pay via UPI, NetBanking, or Debit/Credit Card with instant receipt generation.'),
          _buildFaqItem('How do I add a new family member or vehicle?', 'Open Profile, select "Family Members" or "My Vehicles", and tap the Add button to register their details and RFID tag.'),
        ],
      ),
    );
  }

  Widget _buildHelpTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F5C4D).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF0F5C4D), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.ink)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppColors.mute, fontSize: 12)),
              ],
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(actionText, style: const TextStyle(color: Color(0xFF0F5C4D), fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.help_outline_rounded, size: 18, color: Color(0xFF0F5C4D)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(question, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.ink)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(answer, style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4)),
          ],
        ),
      ),
    );
  }
}
