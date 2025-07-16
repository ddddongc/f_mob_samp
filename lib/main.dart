import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 추가</selection>
import 'package:runus_v1/page/bottom_menu.dart';
import 'package:runus_v1/page/home_screen.dart'; // 예시: HomeScreen 경로

void main() {
  // main 함수 상단에 다음 코드를 추가하여 날짜/시간 형식 초기화
  // WidgetsFlutterBinding.ensureInitialized(); // 이미 있다면 생략 가능
  // await initializeDateFormatting(); // table_calendar 3.0.0 이상에서는 명시적 호출 불필요할 수 있음
  // 만약 특정 로케일 형식이 필요하다면 추가
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '달력 앱',
      // 현지화 설정 시작
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // Cupertino 위젯을 사용한다면 추가
      ],
      supportedLocales: [
        const Locale('ko', 'KR'), // 한국어 지원
        //const Locale('en', 'US'), // 영어 지원 (선택 사항)
        // 다른 지원 언어 추가 가능
      ],
      locale: const Locale('ko', 'KR'), // 기본 로케일을 한국어로 설정

      // 현지화 설정 끝
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BottomMenu(), // 달력이 있는 화면
    );
  }
}

