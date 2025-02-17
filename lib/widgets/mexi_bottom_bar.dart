import 'package:flutter/material.dart';
import 'package:mexi_canje/utils/constants.dart';
import 'package:solar_icons/solar_icons.dart';

class MexiBottomBar extends StatefulWidget {
  const MexiBottomBar(
      {super.key, required this.onItemTapped, required this.selectedIndex});

  final Function(int) onItemTapped;
  final int selectedIndex;

  @override
  State<MexiBottomBar> createState() => _MexiBottomBarState();
}

class _MexiBottomBarState extends State<MexiBottomBar> {
  void _onItemTapped(int index) {
    widget.onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white, // Rounded top corners
            boxShadow: AppStyles.getBarShadowList,
          ),
          padding: const EdgeInsets.symmetric(
              vertical: 12, horizontal: 0), // Add some vertical padding
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildBarItem(
                  index: 0,
                  icon: SolarIconsBold.home, // Heart icon
                  text: 'Inicio',
                ),
                _buildBarItem(
                  index: 1,
                  icon: SolarIconsBold.heart, // Heart icon
                  text: 'Favoritos',
                ),
                _buildBarItem(
                  index: 2,
                  icon: SolarIconsBold.bell, // Bell icon
                  text: 'Avisos',
                ),
                _buildBarItem(
                  index: 3,
                  icon: SolarIconsBold.infoCircle, // Info icon
                  text: 'Info',
                ),
              ]),
        ),
      ],
    );
  }

  Widget _buildBarItem(
      {required int index, required IconData icon, required String text}) {
    if (widget.selectedIndex == index) {
      return _buildToggleButton(
          index: index, icon: icon, text: text, selected: true);
    } else {
      return _buildToggleButton(
          index: index, icon: icon, text: text, selected: false);
    }
  }

  Widget _buildToggleButton({
    required int index,
    required IconData icon,
    required String text,
    required bool selected,
  }) {
    return AnimatedContainer(
      padding: selected
          ? EdgeInsets.all(6)
          : EdgeInsets.all(0), // Padding constante para ambos estados
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      duration: const Duration(milliseconds: 200), // Duración de la animación
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          FloatingActionButton(
            mini: !selected,
            backgroundColor: selected ? AppColors.primary : Colors.transparent,
            elevation: selected ? 10 : 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onPressed: () {
              _onItemTapped(index);
            },
            child: Icon(
              icon,
              size: selected ? 34 : 24,
              color: selected ? Colors.white : AppColors.gray,
            ),
          ),
          AnimatedContainer(
            height: selected ? 20 : 0, // Altura para mostrar/ocultar el texto
            duration: const Duration(milliseconds: 200),
            curve: Curves
                .easeInOut, // Curva de animación para suavizar la transición
            child: AnimatedOpacity(
              // Para una transición de opacidad más suave del texto
              opacity: selected ? 1.0 : 0.0,
              duration: const Duration(
                  milliseconds: 100), // Duración opacidad más corta
              child: Text(
                text,
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
