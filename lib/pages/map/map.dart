import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MapPage> {
  late GoogleMapController mapController;

  late String lat;
  late String lng;

  var locationMessage = '';

  final LatLng _center = const LatLng(40.40012921455346, 49.95120099993589);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  List<LatLng> MyPoints = const [];
  List<LatLng> polygonPoints = const [
    LatLng(40.423307, 49.930280),
  ];

  Future<void> fetchPoints() async {
    final response = await http.get(Uri.parse('http://donmex.az/data/delivery_zone.json'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;

      setState(() {
        MyPoints = data.map((point) => LatLng(point['latitude'], point['longitude'])).toList();
      });
      polygonPoints = MyPoints;
    } else {
      throw Exception('Failed to fetch points');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPoints(); // call fetchPoints method here
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location services are disabled');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      lat = position.latitude.toString();
      lng = position.longitude.toString();

      setState(() {
        locationMessage = 'Latitude: $lat, Longitude: $lng';
      });
    });
  }

// Future<void> _openMap(String lat, String lng) async {
//   String googleURL =
//   'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

//   await canLaunch (googleURL)
//   ? await LaunchUrlString(googleURL)
//   : throw 'Could not launch $googleURL';
// }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                print(polygonPoints);
                _getCurrentLocation().then((value) {
                  lat = '${value.latitude}';
                  lng = '${value.longitude}';
                  setState(() {
                    locationMessage = 'Latitude: $lat, Longitude: $lng';
                  });
                  _liveLocation();
                });
              },
              child: Text('Get current location'),
            ),
            ElevatedButton(
              onPressed: () {
                //_openMap(lat,lng);
              },
              child: Text('Open Google Map'),
            ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.terrain,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 14.0,
                ),
                // circles: {
                //   Circle(
                //   circleId: CircleId("1"),
                //   center: _center,
                //   radius: 530,
                //   strokeWidth: 0,
                //   fillColor: Color.fromRGBO(0, 88, 175, 0.2)
                // ),},
                polygons: {
                  Polygon(
                      polygonId: PolygonId("1"),
                      points: polygonPoints,
                      strokeWidth: 0,
                      fillColor: Color.fromRGBO(0, 175, 122, 0.2))
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
