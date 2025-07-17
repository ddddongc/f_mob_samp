import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:runus_v1/page/bottom_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('themeMode') ?? 'system';

  runApp(MyApp(initialThemeMode: _themeModeFromString(savedTheme)));
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
      title: '일정',
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
