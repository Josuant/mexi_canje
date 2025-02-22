import 'package:flutter/material.dart';
import 'package:mexi_canje/utils/constants.dart';
import 'package:solar_icons/solar_icons.dart';

class MexiSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final Function(String) onSubmitted;
  final String hintText;

  const MexiSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    this.hintText = 'Algo dulce...',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        hintText: hintText,
        prefixIcon: const Icon(
          SolarIconsOutline.magnifier,
          size: 32,
          color: AppColors.gray,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
