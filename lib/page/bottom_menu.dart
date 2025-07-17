import 'package:flutter/material.dart';
import 'package:runus_v1/page/settings_screen.dart';
import 'package:runus_v1/page/tab_item.dart';

import 'content_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';

class BottomMenu extends StatefulWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) onThemeChanged;

  const BottomMenu({
    Key? key,
    required this.themeMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeScreen(),
      MapScreen(),
      ContentScreen(),
      SettingsScreen(
        currentMode: widget.themeMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

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
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: TABS
            .map((tab) => BottomNavigationBarItem(
          icon: Icon(tab.icon),
          label: tab.label,
        ))
            .toList(),
      ),
    );
  }
}

