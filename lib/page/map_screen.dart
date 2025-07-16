import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// 지도 상태를 나타내는 enum
enum MapDisplayState {
  initial,
  running,
  paused,
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(36.34768, 127.3899);

  MapDisplayState _mapDisplayState = MapDisplayState.initial;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _startMap() {
    setState(() {
      _mapDisplayState = MapDisplayState.running;
    });
  }

  void _pauseMap() {
    setState(() {
      _mapDisplayState = MapDisplayState.paused;
    });
  }

  void _resumeMap() {
    setState(() {
      _mapDisplayState = MapDisplayState.running;
    });
  }

  void _stopMap() {
    setState(() {
      _mapDisplayState = MapDisplayState.initial;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        children: [
          if (_mapDisplayState != MapDisplayState.initial)
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 14.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: _mapDisplayState == MapDisplayState.running,
              zoomControlsEnabled: false,
              scrollGesturesEnabled: _mapDisplayState == MapDisplayState.running,
              zoomGesturesEnabled: _mapDisplayState == MapDisplayState.running,
              rotateGesturesEnabled: _mapDisplayState == MapDisplayState.running,
              tiltGesturesEnabled: _mapDisplayState == MapDisplayState.running,
            ),

          if (_mapDisplayState == MapDisplayState.initial)
            Center(
              child: ElevatedButton(
                onPressed: _startMap,
                child: const Text('지도 시작하기'),
              ),
            ),

          if (_mapDisplayState == MapDisplayState.running || _mapDisplayState == MapDisplayState.paused)
            Positioned(
              top: topPadding + 10.0,
              left: 0,
              right: 10.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // "일시정지" 또는 "재시작" 아이콘 버튼
                    IconButton(
                      icon: Icon(
                        _mapDisplayState == MapDisplayState.running
                            ? Icons.pause_circle_filled // 일시정지 아이콘
                            : Icons.play_circle_filled, // 재시작 (재생) 아이콘
                      ),
                      iconSize: 60.0, // 아이콘 크기 조절
                      color: _mapDisplayState == MapDisplayState.running
                          ? Colors.orange // 일시정지 아이콘 색상
                          : Colors.green, // 재시작 아이콘 색상
                      onPressed: _mapDisplayState == MapDisplayState.running ? _pauseMap : _resumeMap,
                      tooltip: _mapDisplayState == MapDisplayState.running ? '일시정지' : '재시작', // 길게 눌렀을 때 표시될 텍스트
                    ),
                    // "종료" 아이콘 버튼
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.stop_circle_outlined), // 종료 아이콘
                      iconSize: 60.0, // 아이콘 크기 조절
                      color: Colors.red, // 종료 아이콘 색상
                      onPressed: _stopMap,
                      tooltip: '종료', // 길게 눌렀을 때 표시될 텍스트
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}