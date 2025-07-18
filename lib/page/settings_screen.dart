import 'package:flutter/material.dart';
import '../util/log_service.dart'; // 실제 경로로 변경

class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentMode;

  const SettingsScreen({
    Key? key,
    required this.onThemeChanged,
    required this.currentMode,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _refreshLogs() {
    setState(() {}); // 로그가 갱신되도록
  }

  @override
  Widget build(BuildContext context) {
    final logs = LogService.all;

    return Scaffold(
      appBar: AppBar(title: const Text("설정 / 로그")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("테마 모드 선택", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Radio<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: widget.currentMode,
                  onChanged: (value) {
                    if (value != null) widget.onThemeChanged(value);
                  },
                ),
                const Text("시스템 기본"),
                const SizedBox(width: 16),
                Radio<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: widget.currentMode,
                  onChanged: (value) {
                    if (value != null) widget.onThemeChanged(value);
                  },
                ),
                const Text("라이트"),
                const SizedBox(width: 16),
                Radio<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: widget.currentMode,
                  onChanged: (value) {
                    if (value != null) widget.onThemeChanged(value);
                  },
                ),
                const Text("다크"),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("📜 로그 출력", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _refreshLogs,
                      tooltip: "새로고침",
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_forever),
                      onPressed: () {
                        LogService.clear();
                        _refreshLogs();
                      },
                      tooltip: "로그 삭제",
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(logs[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
