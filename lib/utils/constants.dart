import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:solar_icons/solar_icons.dart';

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF6F6F6);
  static const Color background2 = Color(0xFFF2EDED);
  static const Color primary = Color(0xFFA93951);
  static const Color secondary = Color(0xFF4CB097);
  static const Color tertiary = Color(0xFF9E39A9);
  static const Color yellow = Color(0xFFF2C94C);
  static const Color orange = Color(0xFFD27D06);
  static const Color gray = Color(0xFFADADB1);
}

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

class AppStyles {
  static final ShapeDecoration mexiDecoration = ShapeDecoration(
    color: Colors.white,
    shadows: getShadows,
    shape: SmoothRectangleBorder(
      borderRadius: BorderRadius.circular(40),
      smoothness: 0.6,
    ),
  );

  static List<BoxShadow> get getShadows {
    return const [
      BoxShadow(
        color: Color(0x338c8c8c),
        offset: Offset(0, 5),
        blurRadius: 11,
      ),
      BoxShadow(
        color: Color(0x2b8c8c8c),
        offset: Offset(0, 20),
        blurRadius: 20,
      ),
      BoxShadow(
        color: Color(0x1a8c8c8c),
        offset: Offset(0, 46),
        blurRadius: 28,
      ),
      BoxShadow(
        color: Color(0x088c8c8c),
        offset: Offset(0, 82),
        blurRadius: 33,
      ),
      BoxShadow(
        color: Colors.transparent,
        offset: Offset(0, 128),
        blurRadius: 36,
      ),
    ];
  }

  static List<BoxShadow> get getBarShadowList {
    return const [
      BoxShadow(
        color: Color(0x56757575),
        blurRadius: 19,
        offset: Offset(0, -9),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Color(0x4C757575),
        blurRadius: 35,
        offset: Offset(0, -35),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Color(0x2D757575),
        blurRadius: 47,
        offset: Offset(0, -79),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Color(0x0C757575),
        blurRadius: 56,
        offset: Offset(0, -140),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Color(0x02757575),
        blurRadius: 61,
        offset: Offset(0, -218),
        spreadRadius: 0,
      )
    ];
  }
}

class AppIcons {
  static const Map<String, IconData> categoryIcons = {
    'Alimentos': SolarIconsBold.chefHat,
    'Bebidas': SolarIconsBold.bottle,
    'Automóviles': SolarIconsBold.cart,
    'Bienes raíces': SolarIconsBold.home1,
    'Electrónicos': SolarIconsBold.smartphone,
    'Hogar': SolarIconsBold.armchair_2,
    'Jardín': SolarIconsBold.leaf,
    'Juguetes': SolarIconsBold.gamepad,
    'Libros': SolarIconsBold.book,
    'Mascotas': SolarIconsBold.paw,
    'Moda': SolarIconsBold.bag,
    'Muebles': SolarIconsBold.chair,
    'Niños': SolarIconsBold.smileCircle,
    'Salud y belleza': SolarIconsBold.heart,
    'Servicios': SolarIconsBold.washingMachine,
    'Tecnología': SolarIconsBold.laptop,
    'Viajes': SolarIconsBold.signpost2,
    'Aerolínea': SolarIconsBold.signpost2,
    'Finanzas': SolarIconsBold.wallet,
    'Servicios Financieros': SolarIconsBold.wallet,
    'Energía': SolarIconsBold.lightbulb,
    'Telecomunicaciones': SolarIconsBold.smartphone,
    'Lácteos': SolarIconsBold.cupHot,
    'Carnes': SolarIconsBold.donutBitten,
    'Botanas': SolarIconsBold.donutBitten,
    'Panadería': SolarIconsBold.donutBitten,
    'Bebidas alcohólicas': SolarIconsBold.bottle,
    'Retail': SolarIconsBold.shop,
  };
}
