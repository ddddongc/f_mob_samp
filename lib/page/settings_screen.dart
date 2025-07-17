import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentMode;

  SettingsScreen({
    required this.onThemeChanged,
    required this.currentMode,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(title: Text("설정")),*/
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("테마 모드 선택", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              children: [
                Radio<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: currentMode,
                  onChanged: (value) {
                    if (value != null) onThemeChanged(value);
                  },
                ),
                Text("시스템 기본"),
                SizedBox(width: 16),
                Radio<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: currentMode,
                  onChanged: (value) {
                    if (value != null) onThemeChanged(value);
                  },
                ),
                Text("라이트"),
                SizedBox(width: 16),
                Radio<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: currentMode,
                  onChanged: (value) {
                    if (value != null) onThemeChanged(value);
                  },
                ),
                Text("다크"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}