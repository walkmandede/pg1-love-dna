import 'package:flutter/material.dart';
import 'package:pg1/core/shared/theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;
  final String? errorText; // ▼ New

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorText != null && errorText!.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: kBottomNavigationBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        // ▼ Error border
        border: hasError ? Border.all(color: Colors.red.shade400, width: 1.2) : null,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(hasError ? 0.03 : 0.05),
            blurRadius: hasError ? 6 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.inputPlaceholder,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
