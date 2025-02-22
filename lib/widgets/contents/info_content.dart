import 'package:flutter/material.dart';
import 'package:mexi_canje/utils/constants.dart';
import 'package:mexi_canje/widgets/mexi_button.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoContent extends StatelessWidget {
  const InfoContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStyles.mexiDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '¡Bienvenido a Mexicanje, tu buscador de productos con sabor a México!  ',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Nuestro objetivo es simple:  conectarte con los productos que buscas de una manera fácil, rápida y con un toque muy especial. Queremos que la experiencia de búsqueda sea  colorida, llena de folclor y que te haga sentir como en casa.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MexiButton(
                  onPressed: () {
                    _launchURL(
                        'mailto:alvarez.nava.antonio@gmail.com', context);
                  },
                  text: 'Correo',
                  icon: SolarIconsOutline.mailbox),
              const SizedBox(width: 10),
              MexiButton(
                  onPressed: () {
                    _launchURL('https://github.com/Josuant', context);
                  },
                  text: 'Github',
                  icon: SolarIconsOutline.code),
            ],
          ),
          const SizedBox(height: 20),
          MexiButton(
              onPressed: () {
                _launchURL(
                    'https://docs.google.com/document/d/e/2PACX-1vRMDr4s7fVqeUMpwFr8C2r1HTdUj9laqwrhBA_L8X8ederFhdQBYExZCrHZfQQgFi0HAU2Nr7pLFIxH/pub',
                    context);
              },
              text: 'Aviso de privacidad',
              icon: SolarIconsOutline.file),
        ],
      ),
    );
  }

  void _launchURL(String url, context) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir la URL: $url')),
      );
    }
  }
}
