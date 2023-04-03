import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: Column(
        children: const [
          _CustomGoogleMap(
            initialPosition: initialPosition,
          ),
          _ChoolCheckButton()
        ],
      ),
    );
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
    required this.initialPosition,
  }) : super(key: key);

  final CameraPosition initialPosition;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialPosition,
      ),
    );
  }
}
