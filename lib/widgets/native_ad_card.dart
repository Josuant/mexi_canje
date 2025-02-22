import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mexi_canje/providers/products_provider.dart';
import 'package:mexi_canje/utils/constants.dart';
import 'package:solar_icons/solar_icons.dart';

class NativeAdCard extends StatefulWidget {
  final ProductsProvider productsProvider;

  const NativeAdCard({super.key, required this.productsProvider});

  @override
  State<NativeAdCard> createState() => _NativeAdCardState();
}

class _NativeAdCardState extends State<NativeAdCard> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  // 	ca-app-pub-3940256099942544/2247696110

  //Test
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  //Live
  // final String _adUnitId = Platform.isAndroid
  //     ? 'ca-app-pub-4173857408990563/2461879943'
  //     : 'ca-app-pub-3940256099942544/3986624511';

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  /// Loads a native ad.
  void _loadAd() {
    _nativeAd = NativeAd(
        adUnitId: _adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            if (kDebugMode) {
              print('$NativeAd loaded.');
            }
            setState(() {
              _isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            _isAdLoaded = false;
            dispose();
          },
          // Called when a click is recorded for a NativeAd.
          onAdClicked: (ad) {},
          // Called when an impression occurs on the ad.
          onAdImpression: (ad) {},
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (ad) {},
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (ad) {},
          // For iOS only. Called before dismissing a full screen view
          onAdWillDismissScreen: (ad) {},
          // Called when an ad receives revenue value.
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.small,
            // Optional: Customize the ad's style.
            mainBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: AppColors.background,
                backgroundColor: AppColors.primary,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: AppColors.primary,
                backgroundColor: AppColors.background,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: AppColors.primary,
                backgroundColor: AppColors.background,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: AppColors.primary,
                backgroundColor: AppColors.background,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: AppStyles.mexiDecoration,
      constraints: const BoxConstraints(
        minWidth: 320, // minimum recommended width
        minHeight: 90, // minimum recommended height
        maxWidth: 400,
        maxHeight: 200,
      ),
      child: _isAdLoaded
          ? AdWidget(ad: _nativeAd!)
          : _nativeAd != null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox(
                  height: 100,
                  child: Center(
                      child: Icon(
                    SolarIconsBold.linkBroken,
                    size: 48,
                    color: Color.fromARGB(179, 160, 160, 160),
                  )),
                ),
    );
  }
}
