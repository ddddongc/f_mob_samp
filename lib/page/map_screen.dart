import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  bool _isLocked = false; // 🔒 화면 잠금 상태

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
      _isLocked = false; // 종료 시 잠금 해제
    });
  }

  void _toggleLock() {
    setState(() {
      _isLocked = !_isLocked;
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
              myLocationButtonEnabled:
              !_isLocked && _mapDisplayState == MapDisplayState.running,
              zoomControlsEnabled: false,
              scrollGesturesEnabled: !_isLocked &&
                  _mapDisplayState == MapDisplayState.running,
              zoomGesturesEnabled: !_isLocked &&
                  _mapDisplayState == MapDisplayState.running,
              rotateGesturesEnabled: !_isLocked &&
                  _mapDisplayState == MapDisplayState.running,
              tiltGesturesEnabled: !_isLocked &&
                  _mapDisplayState == MapDisplayState.running,
            ),

          // 초기 상태 RUN 버튼
          if (_mapDisplayState == MapDisplayState.initial)
            Center(
              child: ElevatedButton(
                onPressed: _startMap,
                child: const Text('RUN!!'),
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
