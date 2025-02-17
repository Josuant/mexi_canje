import 'package:flutter/material.dart';
import 'package:mexi_canje/utils/constants.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:solar_icons/solar_icons.dart';

class AvisoFrame extends StatelessWidget {
  const AvisoFrame({
    super.key,
    this.imageUrl = "https://placehold.co/66x66",
    this.titleText = "Hola!",
    this.bodyText = "Algo salió mal al cargar esta notificación 😖",
  });

  final String imageUrl;
  final String titleText;
  final String bodyText;

  @override
  Widget build(BuildContext context) {
    return SmoothContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(30),
      smoothness: 0.6,
      color: AppColors.background2,
      child: Row(
        children: [
          Image.network(
            imageUrl,
            width: 66,
            height: 66,
            fit: BoxFit.cover,
            errorBuilder: (context, object, stackTrace) =>
                const Icon(SolarIconsOutline.linkBroken),
          ),
          const SizedBox(width: 16), // Consistent spacing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titleText,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  bodyText,
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
