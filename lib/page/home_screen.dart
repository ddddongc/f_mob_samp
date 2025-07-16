import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // 날짜 포맷팅을 위해 추가

// 예시 데이터 모델 (실제 앱에서는 DB나 API로부터 가져올 수 있습니다)
class Event {
  final String title;
  final String description;

  Event({required this.title, required this.description});

  @override
  String toString() => title;
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 날짜별 이벤트 데이터를 저장할 Map
  // 실제 앱에서는 이 데이터를 상태 관리 솔루션(Provider, Riverpod, BLoC 등)을 통해 관리하거나
  // DB 또는 서버에서 가져오는 것이 좋습니다.
  late final Map<DateTime, List<Event>> _events;

  List<Event> _getEventsForDay(DateTime day) {
    // 특정 날짜의 이벤트를 가져옵니다. 시간 부분은 무시하고 날짜만 비교합니다.
    final dateOnly = DateTime.utc(day.year, day.month, day.day);
    return _events[dateOnly] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay; // 초기 선택일을 오늘로 설정

    // 예시 이벤트 데이터 초기화
    _events = {
      DateTime.utc(2025, 7, 20): [
        Event(title: '마라톤 대회 A', description: '오전 9시 시작, 서울 올림픽 공원'),
        Event(title: 'Flutter 스터디', description: '저녁 7시 온라인'),
      ],
      DateTime.utc(2025, 7, 22): [
        Event(title: '프로젝트 마감일', description: '오후 6시까지 제출'),
      ],
      DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day + 3): [
        Event(title: '미팅 준비', description: '발표 자료 검토'),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _selectedDay != null ? _getEventsForDay(_selectedDay!) : [];

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          TableCalendar<Event>( // 이벤트 타입 지정
            locale: 'ko_KR',
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            headerStyle: HeaderStyle(
              titleCentered: true,
              titleTextStyle: const TextStyle(fontSize: 18.0),
              formatButtonVisible: false,
            ),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; // focusedDay도 업데이트하여 뷰를 이동
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            // 이벤트 마커 표시 (선택 사항)
            eventLoader: _getEventsForDay,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildEventsMarker(date, events),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 8.0),
          // 선택된 날짜의 정보 또는 메모를 표시하는 영역
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                //color: Colors.grey[200], // 배경색 (선택 사항)
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(20.0),
                //   topRight: Radius.circular(20.0),
                // ),
              ),
              child: _selectedDay != null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR').format(_selectedDay!),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (selectedEvents.isEmpty)
                    Center(
                      child: Text(
                        '선택된 날짜에 일정이 없습니다.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: selectedEvents.length,
                        itemBuilder: (context, index) {
                          final event = selectedEvents[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              title: Text(event.title),
                              subtitle: Text(event.description),
                              // onTap: () {
                              //   // 이벤트 상세 보기 또는 수정/삭제 기능
                              // },
                            ),
                          );
                        },
                      ),
                    ),
                  // 여기에 메모 입력 필드나 추가 기능을 넣을 수 있습니다.
                  // 예: TextField(decoration: InputDecoration(hintText: '메모 입력...')),
                ],
              )
                  : Center(
                child: Text(
                  '날짜를 선택해주세요.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
      // 새 일정/메모 추가 버튼 (선택 사항)
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // 새 일정 추가 화면으로 이동 또는 다이얼로그 표시
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }

  // 이벤트 마커 UI (간단한 점으로 표시)
  Widget _buildEventsMarker(DateTime date, List<Event> events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
