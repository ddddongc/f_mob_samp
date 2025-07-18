import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../util/log_service.dart';

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
  final TextEditingController _keywordController = TextEditingController();
  StreamSubscription<Position>? _positionStream;
  LatLng? _currentPosition;

  MapDisplayState _mapDisplayState = MapDisplayState.initial;
  bool _isLocked = false; // 🔒 화면 잠금 상태

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _startMap() async {
    final keyword = _keywordController.text.trim();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('위치 권한이 필요합니다. 설정에서 권한을 허용해주세요.')),
        );
        return;
      }
    }
    setState(() {
      _mapDisplayState = MapDisplayState.running;
    });
    // 키워드에 따라 위치공유 로직 분기 처리 가능
    if (keyword.isEmpty) {
      // 자기 위치만 표시하는 로직
    } else {
      // 같은 키워드 쓰는 사람들과 공유하는 로직
    }

    //_startLocationStream();
  }

  void _startLocationStream() {
    final locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 5, // 최소 5m 이동 시 위치 업데이트
    );

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      _currentPosition = LatLng(position.latitude, position.longitude);

      print('[📍 위치 수신됨] lat=${position.latitude}, lng=${position.longitude}');
      LogService.add('[📍 위치 수신됨] lat=${position.latitude}, lng=${position.longitude}');
      if (_mapDisplayState == MapDisplayState.running && !_isLocked) {
        if (mapController != null) {
          mapController.animateCamera(
            CameraUpdate.newLatLng(_currentPosition!),
          );
        } else {
          print('[⚠️ mapController 아직 초기화되지 않음]');
          LogService.add('[⚠️ mapController 아직 초기화되지 않음]');
        }
      }
    });

    print('[🟢 위치 스트림 시작]');
  }
  void _stopLocationStream() {
    _positionStream?.cancel();
    _positionStream = null;
    print('[🔴 위치 스트림 중지]');
    LogService.add('[🔴 위치 스트림 중지]');
  }

  void _pauseMap() {
    setState(() {
      _mapDisplayState = MapDisplayState.paused;
    });
    _stopLocationStream(); // 위치 수신 중지
    print('[⏸ 일시정지]');
    LogService.add('[⏸ 일시정지]');
  }

  void _resumeMap() {
    setState(() {
      _mapDisplayState = MapDisplayState.running;
    });
    _startLocationStream(); // 다시 시작
    print('[▶ 재시작]');
    LogService.add('[▶ 재시작]');
  }

  void _stopMap() {
    setState(() {
      _keywordController.clear();
      _mapDisplayState = MapDisplayState.initial;
      _isLocked = false; // 종료 시 잠금 해제
    });
    _stopLocationStream(); // 위치 수신 종료
    print('[⛔ 종료]');
    LogService.add('[⛔ 종료]');
  }

  void _toggleLock() {
    setState(() {
      _isLocked = !_isLocked;
    });
    if (_isLocked) {
      print('[🔒 화면 잠금]');
      LogService.add('[🔒 화면 잠금]');
    } else {
      print('[🔓 화면 잠금 해제]');
      LogService.add('[🔓 화면 잠금 해제]');
    }
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
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
              myLocationButtonEnabled:
              !_isLocked && _mapDisplayState == MapDisplayState.running,
              zoomControlsEnabled: false,
              scrollGesturesEnabled: !_isLocked && _mapDisplayState == MapDisplayState.running,
              zoomGesturesEnabled: !_isLocked && _mapDisplayState == MapDisplayState.running,
              rotateGesturesEnabled: !_isLocked && _mapDisplayState == MapDisplayState.running,
              tiltGesturesEnabled: !_isLocked && _mapDisplayState == MapDisplayState.running,
            ),

          // 초기 상태 RUN 버튼
          if (_mapDisplayState == MapDisplayState.initial)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: _keywordController,
                      decoration: InputDecoration(
                        hintText: '키워드입력(공백 자기위치만 표시)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _startMap,
                    child: const Text('RUN!!'),
                  ),
                ],
              ),
            ),

          // 잠금된 경우 반투명 어두운 레이어
          if (_isLocked)
            Container(
              color: Colors.black.withOpacity(0.3),
            ),

          if (_mapDisplayState == MapDisplayState.running ||
              _mapDisplayState == MapDisplayState.paused)
            Positioned(
              top: topPadding + 10.0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 일시정지 / 재시작
                    IconButton(
                      icon: Icon(
                        _mapDisplayState == MapDisplayState.running
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                      ),
                      iconSize: 60.0,
                      color: _mapDisplayState == MapDisplayState.running
                          ? Colors.orange
                          : Colors.green,
                      onPressed: _mapDisplayState == MapDisplayState.running
                          ? _pauseMap
                          : _resumeMap,
                      tooltip:
                      _mapDisplayState == MapDisplayState.running ? '일시정지' : '재시작',
                    ),

                    // 잠금 / 잠금해제
                    IconButton(
                      icon: Icon(
                        _isLocked ? Icons.lock : Icons.lock_open,
                      ),
                      iconSize: 60.0,
                      color: _isLocked ? Colors.grey.shade700 : Colors.blue,
                      onPressed: _toggleLock,
                      tooltip: _isLocked ? '잠금 해제' : '화면 잠금',
                    ),

                    // 종료
                    IconButton(
                      icon: const Icon(Icons.stop_circle_outlined),
                      iconSize: 60.0,
                      color: Colors.red,
                      onPressed: _stopMap,
                      tooltip: '종료',
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
