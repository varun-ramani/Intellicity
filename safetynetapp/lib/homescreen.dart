import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ActionButton extends StatelessWidget {
  VoidCallback onPress;
  Color color;
  IconData iconData;
  ActionButton(this.onPress, this.color, this.iconData);

  Widget build(BuildContext build) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: RawMaterialButton(
        padding: EdgeInsets.all(20.0),
        child: Icon(iconData, size: 40.0, color: color),
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

  _getLocation() async {
    var currentLocation = await location.getLocation();
    setState(() {
      _latitude = currentLocation.latitude;
      _longitude = currentLocation.longitude;
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
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
                              ActionButton(getImage, Colors.orange, FontAwesomeIcons.fire),
                              ActionButton(() => {}, Colors.blue, FontAwesomeIcons.water),
                              ActionButton(() => {}, Colors.yellow[500], FontAwesomeIcons.bolt),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              ActionButton(() => getImage, Colors.red, Icons.backspace),
                              ActionButton(() => {}, Colors.purple, Icons.ac_unit),
                              ActionButton(() => {}, Colors.orange, Icons.access_alarm),
                            ],
                          )
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