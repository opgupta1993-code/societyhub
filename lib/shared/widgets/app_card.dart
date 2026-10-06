import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// White rounded card used across screens.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? borderColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor ?? AppColors.line,
          width: borderColor == null ? 1 : 2,
        ),
      ),
      child: child,
    );
  }
}
