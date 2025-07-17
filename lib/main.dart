import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:runus_v1/page/bottom_menu.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 테마 불러오기
  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('themeMode') ?? 'system';

  // UUID 불러오기 또는 생성
  final deviceUUID = await getOrCreateUUID();

  print("기기 UUID: $deviceUUID");
  runApp(MyApp(initialThemeMode: _themeModeFromString(savedTheme)));
}

/// UUID를 SharedPreferences에 저장하고 재사용하는 함수
Future<String> getOrCreateUUID() async {
  final prefs = await SharedPreferences.getInstance();
  final existingUUID = prefs.getString('device_uuid');

  if (existingUUID != null) {
    return existingUUID;
  }

  final newUUID = const Uuid().v4(); // UUID v4 (랜덤 기반)
  await prefs.setString('device_uuid', newUUID);
  return newUUID;
}

ThemeMode _themeModeFromString(String mode) {
  switch (mode) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

String _themeModeToString(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return 'light';
    case ThemeMode.dark:
      return 'dark';
    default:
      return 'system';
  }
}

class MyApp extends StatefulWidget {
  final ThemeMode initialThemeMode;

  const MyApp({required this.initialThemeMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  void _updateTheme(ThemeMode newMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', _themeModeToString(newMode));
    setState(() {
      _themeMode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*title: '일정',*/
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      locale: const Locale('ko', 'KR'),
      home: BottomMenu(
        themeMode: _themeMode,
        onThemeChanged: _updateTheme,
      ),
    );
  }
}
