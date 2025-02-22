import 'package:flutter/material.dart';
import 'package:mexi_canje/models/aviso.dart';
import 'package:mexi_canje/utils/constants.dart';
import 'package:mexi_canje/widgets/contents/aviso_frame.dart';

class AvisosContent extends StatelessWidget {
  final List<Aviso> avisos;

  const AvisosContent({
    super.key,
    required this.avisos,
  });

  @override
  Widget build(BuildContext context) {
    return avisos.isEmpty
        ? Text("No hay :)")
        : Container(
            constraints: BoxConstraints(
              minHeight: 0,
              maxHeight: double.infinity,
            ),
            decoration: AppStyles.mexiDecoration,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: avisos.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AvisoFrame(
                    imageUrl: avisos[index].urlImagen,
                    titleText: avisos[index].title,
                    bodyText: avisos[index].description,
                  ),
                );
              },
            ),
          );
  }
}
