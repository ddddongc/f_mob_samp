import 'package:flutter/material.dart';
import 'package:runus_v1/page/settings_screen.dart';
import 'package:runus_v1/page/tab_item.dart';

import 'content_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({Key? key}) : super(key: key);

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    MapScreen(),
    ContentScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TABS[_selectedIndex].label),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: TABS.map((tab) => BottomNavigationBarItem(
          icon: Icon(tab.icon),
          label: tab.label,
        )).toList(),
      ),
    );
  }
}
