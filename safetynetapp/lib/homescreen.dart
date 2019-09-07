import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ActionButton extends StatelessWidget {
  VoidCallback onPress;
  Color color;
  IconData iconData;
  ActionButton(this.onPress, this.color, this.iconData);

  Widget build(BuildContext build) {
    double width = MediaQuery.of(build).size.width;
    double height = MediaQuery.of(build).size.width - 1;
    return Container(
      padding: EdgeInsets.all(width * ((1 / 10) / 2)),
      child: RawMaterialButton(
        padding: EdgeInsets.all(width * ((1 / 9) / 2)),
        child: Icon(iconData, size: width * (1 / 9), color: color),
        onPressed: onPress,
        splashColor: color.withOpacity(0.5),
        shape: CircleBorder(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PanelController _panelController = PanelController();

  Completer<GoogleMapController> _controller = Completer();
  Location location = Location();

  double _latitude = 0;
  double _longitude = 0;
  IconData _buttonIcon = Icons.keyboard_arrow_up;
  File _image;
  String _description;

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

  Future getDescriptionAndImage(BuildContext context, Color color, String tag) async {

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
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color)),
              labelText: "Description",
              labelStyle: TextStyle(color: color)
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text("OK", style: TextStyle(color: color)),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      }
    );

    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 50.0);

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

    http.post(bobbaServer + "/api/add", body: json.encode(data))
    .then((res) {
      print(res.body);
    });
  }


  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  // map created
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void togglePanel() {
    if (_panelController.isPanelClosed()) {
      _panelController.open();
      setArrowDown();
    } else {
      _panelController.close();
      setArrowUp();
    }
  }

  void setArrowUp() {
    setState(() {
      _buttonIcon = Icons.keyboard_arrow_up;
    });
  }

  void setArrowDown() {
    setState(() {
      _buttonIcon = Icons.keyboard_arrow_down;
    });
  }

  @override
  Widget build(BuildContext context) {
    GoogleMap map = GoogleMap(
      onMapCreated: _onMapCreated,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      // set init cam pos
      initialCameraPosition:
          CameraPosition(target: LatLng(_latitude, _longitude), zoom: 14.0),
    );

    return Scaffold(
        body: SlidingUpPanel(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            controller: _panelController,
            renderPanelSheet: false,
            onPanelOpened: setArrowDown,
            onPanelClosed: setArrowUp,
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
                        child: IconButton(icon: Icon(_buttonIcon), onPressed: togglePanel),
                        padding: EdgeInsets.all(20.0)
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              ActionButton(() => addEntry("fire", Colors.orange, context), Colors.orange, FontAwesomeIcons.fire),
                              ActionButton(() => addEntry("water", Colors.blue, context), Colors.blue, FontAwesomeIcons.water),
                              ActionButton(() => addEntry("bolt", Colors.yellow[500], context), Colors.yellow[500], FontAwesomeIcons.bolt),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ],
                      )
                    ],
                  )
                ),
              ],
            ),
            body: Container(
              child: map,
              height: 200,
              width: 200
            )));
  }
}