import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

/// The latitude in degrees between -90.0 and 90.0, both inclusive.
double latitude = 0;

/// The longitude in degrees between -180.0 (inclusive) and 180.0 (exclusive).
double longitude = 0;

LatLng center = new LatLng(39.952217, -75.193214);

_getLocation() async {
  var location = new Location();
  try {
    var currentLocation = await location.getLocation();

    latitude = currentLocation.latitude;
    longitude = currentLocation.longitude;
    center = new LatLng(latitude, longitude);
  
  } on Exception {
    print("error in getting location coords");
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  Completer<GoogleMapController> _controller = Completer();

// cont loc
// var location = new Location();

// location.onLocationChanged().listen((LocationData currentLocation) {
//   print(currentLocation.latitude);
//   print(currentLocation.longitude);
// });

  // map created
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('SafetyNet'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,

          // set init cam pos
          initialCameraPosition: CameraPosition(
            target: center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}
