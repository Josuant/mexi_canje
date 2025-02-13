import 'package:flutter/material.dart';
import 'package:mexi_canje/utils/constants.dart';

class MexiBottomBar extends StatefulWidget {
  const MexiBottomBar({super.key});

  @override
  State<MexiBottomBar> createState() => _MexiBottomBarState();
}

class _MexiBottomBarState extends State<MexiBottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation or actions based on the selected index
    switch (index) {
      case 0:
        print('Home (Inicio) tapped');
        break;
      case 1:
        print('Favorites tapped');
        break;
      case 2:
        print('Notifications tapped');
        break;
      case 3:
        print('Information tapped');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20)), // Rounded top corners
            boxShadow: AppStyles.getBarShadowList,
          ),
          padding: const EdgeInsets.symmetric(
              vertical: 12, horizontal: 0), // Add some vertical padding
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildBarItem(
                index: 0,
                icon: const Icon(Icons.favorite_border,
                    color: Color(0xFF2EB899)), // Heart icon,
              ),
              _buildBarItem(
                index: 1,
                icon: const Icon(Icons.favorite_border,
                    color: Color(0xFF2EB899)), // Heart icon
              ),
              _buildBarItem(
                index: 2,
                icon: const Icon(Icons.notifications_none,
                    color: Color(0xFF2EB899)), // Bell icon
              ),
              _buildBarItem(
                index: 3,
                icon: const Icon(Icons.info_outline,
                    color: Color(0xFF2EB899)), // Info icon
              ),
            ],
          ),
        ),
        Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _selectedIndex == 0
                  ? Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 2,
                        children: [
                          ElevatedButton.icon(
                              onPressed: () {
                                _onItemTapped(0);
                              },
                              label: Text('',
                                  style: TextStyle(color: AppColors.white)),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    AppColors.primary),
                                elevation: WidgetStateProperty.all<double>(2.0),
                              ),
                              icon: Icon(
                                Icons.home,
                                color: AppColors.white,
                              )),
                          IconButton.filled(
                            iconSize: 45,
                            onPressed: () => _onItemTapped(0),
                            color: AppColors.primary,

                            style: ButtonStyle(
                              elevation: WidgetStateProperty.all<double>(2.0),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  AppColors.primary),
                            ),
                            icon: const Icon(Icons.home,
                                color: AppColors.white), // Home icon
                          ),
                          Text(
                            'Inicio',
                            style: TextStyle(color: AppColors.primary),
                          )
                        ],
                      ),
                    )
                  : SizedBox(
                      width: 50,
                    ),
            ]),
      ],
    );
  }

  Widget _buildBarItem({
    required int index,
    required Widget icon,
  }) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0), // Add horizontal padding for each item
        child: icon,
      ),
    );
  }
}
