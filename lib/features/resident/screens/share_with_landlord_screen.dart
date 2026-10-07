import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

/// Screen C9: Share with Landlord / Shared Access Screen (matches wireframe image exactly)
class ShareWithLandlordScreen extends ConsumerStatefulWidget {
  const ShareWithLandlordScreen({super.key});

  @override
  ConsumerState<ShareWithLandlordScreen> createState() => _ShareWithLandlordScreenState();
}

class _ShareWithLandlordScreenState extends ConsumerState<ShareWithLandlordScreen> {
  // Permission Toggles
  bool _canSeeRentPayments = true;
  bool _canSeeSocietyCharges = false;
  bool _canSeeIssues = true;
  bool _canSeeAgreementDocs = true;
  bool _isAccessActive = true;

  void _handleRevokeAccess() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Revoke Access?', style: TextStyle(fontWeight: FontWeight.w800)),
          content: const Text(
            'Mr. Sharma will no longer be able to view your shared rent receipts and documents.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: AppColors.mute)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() => _isAccessActive = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Landlord access revoked successfully!'),
                    backgroundColor: AppColors.red,
                  ),
                );
              },
              child: const Text('Revoke'),
            ),
          ],
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
          'Share with landlord',
          style: text.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
            fontSize: 26,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 600));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Landlord Profile Card
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Avatar Circle (Initial S)
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: AppColors.tint,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'S',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Name & Phone
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mr. Sharma',
                            style: text.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                              fontSize: 19,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '+91 98xxxxxx20',
                            style: text.bodyMedium?.copyWith(
                              color: AppColors.mute,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status Badge (Active / Revoked)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: _isAccessActive ? AppColors.tint : const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _isAccessActive ? 'Active' : 'Revoked',
                        style: TextStyle(
                          color: _isAccessActive ? AppColors.primary : AppColors.red,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Section Label: He can see
              Text(
                'He can see',
                style: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.mute,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 12),

              // Toggle 1: Rent payments
              _buildToggleCard(
                title: 'Rent payments',
                value: _canSeeRentPayments,
                onChanged: _isAccessActive
                    ? (val) => setState(() => _canSeeRentPayments = val)
                    : null,
              ),
              const SizedBox(height: 12),

              // Toggle 2: Society charges
              _buildToggleCard(
                title: 'Society charges',
                value: _canSeeSocietyCharges,
                onChanged: _isAccessActive
                    ? (val) => setState(() => _canSeeSocietyCharges = val)
                    : null,
              ),
              const SizedBox(height: 12),

              // Toggle 3: Issues I raise
              _buildToggleCard(
                title: 'Issues I raise',
                value: _canSeeIssues,
                onChanged: _isAccessActive
                    ? (val) => setState(() => _canSeeIssues = val)
                    : null,
              ),
              const SizedBox(height: 12),

              // Toggle 4: Agreement & docs
              _buildToggleCard(
                title: 'Agreement & docs',
                value: _canSeeAgreementDocs,
                onChanged: _isAccessActive
                    ? (val) => setState(() => _canSeeAgreementDocs = val)
                    : null,
              ),
              const SizedBox(height: 36),

              // Action Button: Revoke access
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _isAccessActive ? AppColors.primary : AppColors.mute,
                    side: BorderSide(
                      color: _isAccessActive ? AppColors.primary : AppColors.line,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _isAccessActive ? _handleRevokeAccess : null,
                  child: Text(
                    _isAccessActive ? 'Revoke access' : 'Access Revoked',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              fontSize: 16,
            ),
          ),
          Switch.adaptive(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.line,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
