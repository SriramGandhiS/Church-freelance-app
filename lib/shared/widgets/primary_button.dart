import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({super.key, required this.label, required this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : Text(label),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SecondaryButton({super.key, required this.label, required this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
          : Text(label),
    );
  }
}

class DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const DangerButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blushLight,
        foregroundColor: AppColors.error,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label),
    );
  }
}
