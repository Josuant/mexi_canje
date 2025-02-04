import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:solar_icons/solar_icons.dart';

class NativeAdCard extends StatefulWidget {
  const NativeAdCard({super.key});

  @override
  State<NativeAdCard> createState() => _NativeAdCardState();
}

class _NativeAdCardState extends State<NativeAdCard> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  // TODO: replace this test ad unit with your own ad unit.
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-4173857408990563/2461879943'
      : 'ca-app-pub-3940256099942544/3986624511';

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    setState(() {
      _isAdLoaded = false;
    });

    _nativeAd = NativeAd(
      adUnitId: _adUnitId,
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: Colors.blue,
          style: NativeTemplateFontStyle.bold,
          size: 12,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          backgroundColor: Colors.white,
          style: NativeTemplateFontStyle.normal,
          size: 16,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          backgroundColor: Colors.white,
          style: NativeTemplateFontStyle.normal,
          size: 16,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          backgroundColor: Colors.white,
          style: NativeTemplateFontStyle.normal,
          size: 16,
        ),
        mainBackgroundColor: Colors.white,
        cornerRadius: 15.0,
      ),
      factoryId: 'adFactoryExample', // Add a factoryId
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _nativeAd = ad as NativeAd;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() {
            _nativeAd = null;
            _isAdLoaded = false;
          });
        },
        onAdImpression: (ad) {
          debugPrint('$NativeAd impression occurred');
        },
        onAdClicked: (ad) {
          debugPrint('$NativeAd was clicked');
        },
        onAdClosed: (ad) {
          debugPrint('$NativeAd closed');
        },
        onAdOpened: (ad) {
          debugPrint('$NativeAd opened');
        },
      ),
      request: const AdRequest(),
      nativeAdOptions: NativeAdOptions(
        adChoicesPlacement: AdChoicesPlacement
            .bottomRightCorner, // Ejemplo de AdChoices placement
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isAdLoaded && _nativeAd != null)
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 320, // minimum recommended width
                    minHeight: 90, // minimum recommended height
                    maxWidth: 400,
                    maxHeight: 200,
                  ),
                  child: AdWidget(ad: _nativeAd!),
                ), // Función para construir la card del anuncio
              if (!_isAdLoaded)
                _nativeAd == null
                    ? const SizedBox(
                        height: 100, // Altura placeholder mientras carga
                        child: Center(
                            child: Icon(
                          SolarIconsBold.linkBroken,
                          size: 48,
                          color: Color.fromARGB(179, 160, 160, 160),
                        )),
                      )
                    : const SizedBox(
                        height: 100, // Altura placeholder mientras carga
                        child: Center(child: CircularProgressIndicator()),
                      ),
            ],
          ),
        ),
      ),
    );
  }
}
