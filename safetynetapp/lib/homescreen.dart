import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flt_telephony_info/flt_telephony_info.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as prefix0;
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:vibration/vibration.dart';

class ActionButton extends StatelessWidget {
  VoidCallback onPress;
  Color color;
  IconData iconData;
  String label;
  ActionButton(this.onPress, this.color, this.iconData, this.label);

  Widget build(BuildContext build) {
    double width = MediaQuery.of(build).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(width * ((1 / 12) / 2)),
          child: RawMaterialButton(
            padding: EdgeInsets.all(width * ((1 / 12) / 2)),
            child: Icon(iconData, size: width * (1 / 12), color: color),
            onPressed: onPress,
            splashColor: color.withOpacity(0.5),
            shape: CircleBorder(),
          ),
        ),
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 15.0))
      ],
    );
  }
}



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget initialButtons() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            ActionButton(() {
              setState(() {
                _buttons = hazardButtons();
              });
            }, Colors.red, FontAwesomeIcons.exclamationTriangle, "Hazard"),
            ActionButton(() {
              setState(() {
                _buttons = crimeButtons();
              });
            }, Colors.black, FontAwesomeIcons.skullCrossbones, "Crime"),
            ActionButton(() {
              setState(() {
                _buttons = utilButtons();
              });
            }, Colors.green, FontAwesomeIcons.lightbulb, "Utility"),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ],
    );
  }

  Widget hazardButtons() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            ActionButton(
                () => addMarker("Fire"), Colors.orange, FontAwesomeIcons.fireAlt, "Fire",
                ),
            ActionButton(
                () => addMarker("Accident"), Colors.blue, FontAwesomeIcons.carCrash, "Accident"),
            ActionButton(() =>  addMarker("Infra Damage"), Colors.black, FontAwesomeIcons.hammer,
                "Infra Damage"),
          ],
        ),
      ],
    );
  }

  Widget crimeButtons() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ActionButton(
                () =>  addMarker("Violent"), Colors.red, FontAwesomeIcons.dizzy, "Violent"),
            ActionButton(
                () =>  addMarker("Not Violent"), Colors.blue, FontAwesomeIcons.user, "Not Violent"),
          ],
        ),
      ],
    );
  }

  Widget utilButtons() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            ActionButton(
                () => {}, Colors.blue, FontAwesomeIcons.restroom, "Restroom"),
            ActionButton(
                () => {}, Colors.red, FontAwesomeIcons.parking, "Parking"),
            ActionButton(() => {}, Colors.green, FontAwesomeIcons.trash,
                "Trash"),
          ],
        ),
      ],
    );
  }


  PanelController _panelController = PanelController();
  Completer<GoogleMapController> _controller = Completer();

  Location location = Location();

  double _latitude = 0;
  double _longitude = 0;
  IconData _buttonIcon;
  File _image;
  String _description;

  Set<Marker> _markers = Set();
  static const LatLng _center = const LatLng(0, 0);
  LatLng _lastPosition = _center;

Future addMarker(String danger) async {
  if (danger == null) {
    danger = "danger";
  }
  print("yeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"); // for testing purps
  _getLocation();
  Marker mark = Marker(
      position: LatLng(_latitude, _longitude),
      markerId: MarkerId(danger),
      infoWindow: InfoWindow(title: danger)
      );

  // setState(() {
    _markers.add(mark);
  // });

}


  Widget _buttons;

  void initState() {
    super.initState();
    _buttonIcon = Icons.keyboard_arrow_up;
    _buttons = initialButtons();
  }

  void addEntry(String tag, Color color, BuildContext context) async {
    await getDescriptionAndImage(context, color, tag);
    await uploadToServer(tag);
  }

  _getLocation() async {
    var currentLocation = await location.getLocation();
    setState(() {
      _latitude = currentLocation.latitude;
      _longitude = currentLocation.longitude;
    });
  }

  Future getDescriptionAndImage(
      BuildContext context, Color color, String tag) async {
    TextEditingController descriptionController = TextEditingController();
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(tag.toUpperCase()),
            content: TextField(
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: color)),
                  labelText: "Description",
                  labelStyle: TextStyle(color: color)),
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text("OK", style: TextStyle(color: color)),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });

    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 450.0);
    image = await FlutterExifRotation.rotateImage(path: image.path);

    setState(() {
      _image = image;
      _description = descriptionController.value.text;
    });

    return image;
  }

  Future uploadToServer(String tag) async {
    await _getLocation();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String authtoken = prefs.getString("authtoken");
    Map<String, String> data = {
      "authtoken": authtoken,
      "longitude": _longitude.toString(),
      "latitude": _latitude.toString(),
      "image": base64Encode(_image.readAsBytesSync()),
      "description": _description,
      "tags": json.encode([tag])
    };

    print("Sending ${json.encode(data)}");

    http.post(bobbaServer + "/api/add", body: json.encode(data)).then((res) {
      print(res.body);
    });
  }

  // map created
  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    mapController = controller;
  }

  void setButtons(Widget buttons) {
    setState(() {
      _buttons = buttons;
    });
  }

  void togglePanel() {
    if (_panelController.isPanelClosed()) {
      _panelController.open();
      setArrow("down");
    } else {
      _panelController.close();
      setArrow("up");
    }
  }

  void setArrow(String direction) {
    setState(() {
      _buttonIcon = (direction == "up")
          ? Icons.keyboard_arrow_up
          : Icons.keyboard_arrow_down;
    });
  }

  void _onPressed() {
    // todo: connect this to twilio
  }

  @override
  Widget build(BuildContext context) {
    GoogleMap map = GoogleMap(
      onMapCreated: _onMapCreated,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      // set init cam pos
      initialCameraPosition:
          CameraPosition(target: LatLng(_latitude, _longitude), zoom: 17.0),
      markers: Set.from(_markers),
    );

    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   title: Text("Intellicity", style: TextStyle(color: Colors.black, fontSize: 20.0)),
        //   centerTitle: true,
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)))
        // ),
        body: SlidingUpPanel(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            controller: _panelController,
            renderPanelSheet: false,
            onPanelOpened: () => setArrow("down"),
            onPanelClosed: () {
              setArrow("up");
              setState(() {
                _buttons = initialButtons();
              });
              Vibration.vibrate(duration: 100);
            },

            panel: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: <Widget>[
                        Container(
                            child: IconButton(
                                icon: Icon(_buttonIcon),
                                onPressed: togglePanel),
                            padding: EdgeInsets.all(20.0)),
                        AnimatedSwitcher(
                          duration: const Duration(seconds: 2),
                          child: _buttons,
                        )
                      ],
                    )),
              ],
            ),
            body: Container(child: map, height: 200, width: 200)));

  }
}
