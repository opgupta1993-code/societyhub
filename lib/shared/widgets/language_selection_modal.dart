import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

/// Modal Bottom Sheet for Language Selection (English, Hindi, Marathi, Gujarati)
void showLanguageSelectionSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: Colors.white,
    builder: (modalContext) {
      return Consumer(
        builder: (context, ref, _) {
          final activeLocale = ref.watch(localeProvider);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Language / भाषा चुनें',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                            fontSize: 20,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.mute),
                      onPressed: () => Navigator.pop(modalContext),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildLanguageItem(
                  context,
                  ref,
                  modalContext,
                  label: 'English',
                  subLabel: 'Default',
                  code: 'en',
                  activeCode: activeLocale.languageCode,
                ),
                const SizedBox(height: 8),
                _buildLanguageItem(
                  context,
                  ref,
                  modalContext,
                  label: 'हिंदी (Hindi)',
                  subLabel: 'हिन्दी भाषा',
                  code: 'hi',
                  activeCode: activeLocale.languageCode,
                ),
                const SizedBox(height: 8),
                _buildLanguageItem(
                  context,
                  ref,
                  modalContext,
                  label: 'मराठी (Marathi)',
                  subLabel: 'मराठी भाषा',
                  code: 'mr',
                  activeCode: activeLocale.languageCode,
                ),
                const SizedBox(height: 8),
                _buildLanguageItem(
                  context,
                  ref,
                  modalContext,
                  label: 'ગુજરાતી (Gujarati)',
                  subLabel: 'ગુજરાતી ભાષા',
                  code: 'gu',
                  activeCode: activeLocale.languageCode,
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildLanguageItem(
  BuildContext context,
  WidgetRef ref,
  BuildContext modalContext, {
  required String label,
  required String subLabel,
  required String code,
  required String activeCode,
}) {
  final isSelected = activeCode == code;

  return InkWell(
    onTap: () {
      ref.read(localeProvider.notifier).changeLocale(code);
      Navigator.pop(modalContext);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Language switched to $label'),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.primary,
        ),
      );
    },
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.tint : AppColors.bg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.line,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: isSelected ? AppColors.primary : AppColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.mute,
                ),
              ),
            ],
          ),
          if (isSelected)
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.primary,
              size: 22,
            ),
        ],
      ),
    ),
  );
}
