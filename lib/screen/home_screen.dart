import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // latitude-위도 , longitude - 경도
  static const LatLng companyLatLng = LatLng(
    37.569448,
    126.835006,
  );

  static const CameraPosition initialPosition = CameraPosition(
    target: companyLatLng,
    zoom: 17,
  );
  static double okDistance = 100;

  static Circle withinDistanceCircle = Circle(
    circleId: const CircleId('withinDistanceCircle'),
    center: companyLatLng,
    fillColor: Colors.blue.withOpacity(0.5),
    radius: okDistance,
    strokeColor: Colors.blue,
    strokeWidth: 1,
  );

  static Circle notWithinDistanceCircle = Circle(
    circleId: const CircleId('notWithinDistanceCircl'),
    center: companyLatLng,
    fillColor: Colors.red.withOpacity(0.5),
    radius: okDistance,
    strokeColor: Colors.red,
    strokeWidth: 1,
  );
  static Circle checkDoneCircle = Circle(
    circleId: const CircleId('notWithinDistanceCircl'),
    center: companyLatLng,
    fillColor: Colors.green.withOpacity(0.5),
    radius: okDistance,
    strokeColor: Colors.green,
    strokeWidth: 1,
  );

  static const Marker marker = Marker(
    markerId: MarkerId('markerId'),
    position: companyLatLng,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder(
        future: checkPermission(),
        // initialData: InitialData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          print(snapshot
              .connectionState); // connectionState - waiting future 로딩중일때 , 끝이면 done이 뜸

          if (snapshot.data == '위치 권한이 허가 되었습니다') {
            return StreamBuilder<Position>(
                // 현재 위치 정보 얻는 것
                stream: Geolocator.getPositionStream(),
                builder: (context, snapshot) {
                  bool isWithinRange = false;

                  if (snapshot.hasData) {
                    // 현재 위치
                    final start = snapshot.data!;
                    // 회사
                    const end = companyLatLng;

                    final distance = Geolocator.distanceBetween(
                      start.latitude,
                      start.longitude,
                      end.latitude,
                      end.longitude,
                    );
                    if (distance < okDistance) {
                      isWithinRange = true;
                    }
                  }

                  print(snapshot.data);
                  return Column(
                    children: [
                      _CustomGoogleMap(
                        marker: marker,
                        circle: isWithinRange
                            ? withinDistanceCircle
                            : notWithinDistanceCircle,
                        initialPosition: initialPosition,
                      ),
                      const _ChoolCheckButton()
                    ],
                  );
                });
          }
          return Center(
            child: Text(snapshot.data),
          );
        },
      ),
    );
  }

  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return '위치 서비스를 활성화 해주세요';
    }
    LocationPermission checkedPermission = await Geolocator.checkPermission();
    if (checkedPermission == LocationPermission.denied) {
      //권한요청
      checkedPermission = await Geolocator.requestPermission();
      if (checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요';
      }
    }
    if (checkedPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 세팅에서 허가해주세요';
    }
    return '위치 권한이 허가 되었습니다';
  }

  AppBar renderAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        '오늘도 출근 ',
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class _ChoolCheckButton extends StatelessWidget {
  const _ChoolCheckButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Text(
        '출근',
      ),
    );
  }
}

class _CustomGoogleMap extends StatelessWidget {
  const _CustomGoogleMap({
    Key? key,
    required this.circle,
    required this.initialPosition,
    required this.marker,
  }) : super(key: key);

  final CameraPosition initialPosition;
  final Circle circle;
  final Marker marker;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        circles: {circle},
        markers: {marker},
      ),
    );
  }
}
