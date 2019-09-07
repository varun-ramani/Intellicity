import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Completer<GoogleMapController> _controller = Completer();
  Location location = Location();

  double _latitude = 0;
  double _longitude = 0;

  _getLocation() async {
    var currentLocation = await location.getLocation();
    setState(() {
      _latitude = currentLocation.latitude;
      _longitude = currentLocation.longitude;
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }


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
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          // set init cam pos
          initialCameraPosition: CameraPosition(
            target: LatLng(_latitude, _longitude),
            zoom: 14.0
          ),
        ),
      ),
    );
  }
}
