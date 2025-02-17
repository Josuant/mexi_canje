import 'package:flutter/material.dart';
import 'package:mexi_canje/utils/constants.dart';

class MexiButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;

  const MexiButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        elevation: 10,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
        textStyle: const TextStyle(fontSize: 16),
      ),
    );
  }
}
