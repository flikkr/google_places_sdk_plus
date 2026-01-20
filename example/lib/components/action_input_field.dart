import 'package:flutter/material.dart';

class ActionInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final ButtonStyle? filledButtonStyle;
  final Color? loadingColor;
  final String? title;

  const ActionInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.buttonText,
    required this.buttonIcon,
    required this.onPressed,
    required this.isLoading,
    this.isEnabled = true,
    this.filledButtonStyle,
    this.loadingColor,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null) ...[
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  title!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),
        ],
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabled: isEnabled,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: FilledButton.icon(
            onPressed: isEnabled || isLoading ? onPressed : null,
            icon: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color:
                          loadingColor ??
                          Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                : Icon(buttonIcon),
            label: Text(isLoading ? 'Please wait...' : buttonText),
            style:
                filledButtonStyle ??
                FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
