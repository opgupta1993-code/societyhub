import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

/// Screen B2: New Issue / Raise Complaint Screen (matches wireframe image exactly)
class RaiseIssueScreen extends ConsumerStatefulWidget {
  const RaiseIssueScreen({super.key});

  @override
  ConsumerState<RaiseIssueScreen> createState() => _RaiseIssueScreenState();
}

class _RaiseIssueScreenState extends ConsumerState<RaiseIssueScreen> {
  String _selectedCategory = 'Plumbing';
  String _sendTo = 'Society'; // 'Society' (Common areas) or 'Landlord' (Inside flat)
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _attachedPhotos = [];

  final List<String> _categories = [
    'Plumbing',
    'Electrical',
    'Lift',
    'Cleaning',
    'Security',
    'Parking',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe the problem before submitting.'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Issue reported to $_sendTo under $_selectedCategory!'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        context.pop();
      }
    });
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
          'New issue',
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
              // 1. Category Section
              Text(
                'Category',
                style: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.mute,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _categories.map((cat) => _buildCategoryPill(cat)).toList(),
              ),
              const SizedBox(height: 24),

              // 2. Send To Section
              Text(
                'Send to',
                style: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.mute,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildSendToCard(
                      title: 'Society',
                      subtitle: 'Common areas',
                      value: 'Society',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildSendToCard(
                      title: 'Landlord',
                      subtitle: 'Inside flat',
                      value: 'Landlord',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. Problem Description Input Box
              AppCard(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  style: text.bodyLarge?.copyWith(
                    color: AppColors.ink,
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Describe the problem...',
                    hintStyle: TextStyle(
                      color: AppColors.mute,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 4. Add Photos Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _attachedPhotos.add('photo_${_attachedPhotos.length + 1}.jpg');
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Photo attached!')),
                  );
                },
                child: AppCard(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.camera_alt_rounded,
                        color: AppColors.mute,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _attachedPhotos.isEmpty
                            ? 'Add photos'
                            : 'Add photos (${_attachedPhotos.length} attached)',
                        style: text.bodyLarge?.copyWith(
                          color: AppColors.mute,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // 5. Submit Issue CTA Button
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
                  onPressed: _handleSubmit,
                  child: const Text('Submit issue'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildCategoryPill(String title) {
    final isSelected = _selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedCategory = title);
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

  Widget _buildSendToCard({
    required String title,
    required String subtitle,
    required String value,
  }) {
    final isSelected = _sendTo == value;
    return GestureDetector(
      onTap: () {
        setState(() => _sendTo = value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.line,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.mute,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
