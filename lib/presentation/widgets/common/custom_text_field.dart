import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// A custom validated text form field adhering to the design system.
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? errorText;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? minLines;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.errorText,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onSubmitted,
    this.onChanged,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceSM),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          autofocus: autofocus,
          maxLines: maxLines,
          minLines: minLines,
          textInputAction: textInputAction,
          validator: validator,
          onFieldSubmitted: onSubmitted,
          onChanged: onChanged,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}
