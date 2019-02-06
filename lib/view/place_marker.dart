/*https://medium.com/flutter-community/flutter-how-to-integrate-google-maps-experimental-5ec8485c0c59*/

import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:klymbr/network/client.dart';
import 'page.dart';
import 'package:klymbr/data.dart' show globalToken;

class PlaceMarkerPage extends Page {
  PlaceMarkerPage() : super(const Icon(Icons.place), 'Place marker');

  @override
  Widget build(BuildContext context) {
    return const PlaceMarkerBody();
  }
}

class PlaceMarkerBody extends StatefulWidget {
  const PlaceMarkerBody();

  @override
  State<StatefulWidget> createState() => PlaceMarkerBodyState();
}

class PlaceMarkerBodyState extends State<PlaceMarkerBody> {
  PlaceMarkerBodyState();

  static final LatLng center = const LatLng(48.8534, 2.3488);

  GoogleMapController controller;
  int _markerCount = 0;
  Marker _selectedMarker;

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
    controller.onMarkerTapped.add(_onMarkerTapped);
    Connection connectionClient = new Connection()..token = globalToken;

    connectionClient.getJsonList("/rooms/").then((List<dynamic> value) {
      print(value);
      value.forEach((value) => controller.addMarker(MarkerOptions(
            position: LatLng(
              value['latitude'],
              value['longitude'],
            ),
            infoWindowText: InfoWindowText('${value['title']}',
                '${value['paths'].length} voies interactives'),
          )));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.onMarkerTapped?.remove(_onMarkerTapped);
    super.dispose();
  }

  void _onMarkerTapped(Marker marker) {
    if (_selectedMarker != null) {
      _updateSelectedMarker(
        const MarkerOptions(icon: BitmapDescriptor.defaultMarker),
      );
    }
    setState(() {
      _selectedMarker = marker;
    });
    _updateSelectedMarker(
      MarkerOptions(
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
      ),
    );
  }

  void _updateSelectedMarker(MarkerOptions changes) {
    controller.updateMarker(_selectedMarker, changes);
  }

  void _add() {
    controller.addMarker(MarkerOptions(
      position: LatLng(
        center.latitude + sin(_markerCount * pi / 6.0) / 20.0,
        center.longitude + cos(_markerCount * pi / 6.0) / 20.0,
      ),
      infoWindowText: InfoWindowText('Marker #${_markerCount + 1}', '*'),
    ));
    setState(() {
      _markerCount += 1;
    });
  }

  void _remove() {
    controller.removeMarker(_selectedMarker);
    setState(() {
      _selectedMarker = null;
      _markerCount -= 1;
    });
  }

  void _changePosition() {
    final LatLng current = _selectedMarker.options.position;
    final Offset offset = Offset(
      center.latitude - current.latitude,
      center.longitude - current.longitude,
    );
    _updateSelectedMarker(
      MarkerOptions(
        position: LatLng(
          center.latitude + offset.dy,
          center.longitude + offset.dx,
        ),
      ),
    );
  }

  void _changeAnchor() {
    final Offset currentAnchor = _selectedMarker.options.anchor;
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    _updateSelectedMarker(MarkerOptions(anchor: newAnchor));
  }

  Future<void> _changeInfoAnchor() async {
    final Offset currentAnchor = _selectedMarker.options.infoWindowAnchor;
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    _updateSelectedMarker(MarkerOptions(infoWindowAnchor: newAnchor));
  }

  Future<void> _toggleDraggable() async {
    _updateSelectedMarker(
      MarkerOptions(draggable: !_selectedMarker.options.draggable),
    );
  }

  Future<void> _toggleFlat() async {
    _updateSelectedMarker(MarkerOptions(flat: !_selectedMarker.options.flat));
  }

  Future<void> _changeInfo() async {
    final InfoWindowText currentInfo = _selectedMarker.options.infoWindowText;
    _updateSelectedMarker(MarkerOptions(
      infoWindowText: InfoWindowText(
        currentInfo.title,
        currentInfo.snippet + '*',
      ),
    ));
  }

  Future<void> _changeAlpha() async {
    final double current = _selectedMarker.options.alpha;
    _updateSelectedMarker(
      MarkerOptions(alpha: current < 0.1 ? 1.0 : current * 0.75),
    );
  }

  Future<void> _changeRotation() async {
    final double current = _selectedMarker.options.rotation;
    _updateSelectedMarker(
      MarkerOptions(rotation: current == 330.0 ? 0.0 : current + 30.0),
    );
  }

  Future<void> _toggleVisible() async {
    _updateSelectedMarker(
      MarkerOptions(visible: !_selectedMarker.options.visible),
    );
  }

  Future<void> _changeZIndex() async {
    final double current = _selectedMarker.options.zIndex;
    _updateSelectedMarker(
      MarkerOptions(zIndex: current == 12.0 ? 0.0 : current + 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: MediaQueryData.fromWindow(ui.window).size.width,
            height: MediaQueryData.fromWindow(ui.window).size.height,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(48.8534, 2.3488),
                zoom: 5.0,
              ),
            ),
          ),
        ),
/*        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('add'),
                          onPressed: (_markerCount == 12) ? null : _add,
                        ),
                        FlatButton(
                          child: const Text('remove'),
                          onPressed: (_selectedMarker == null) ? null : _remove,
                        ),
                        FlatButton(
                          child: const Text('change info'),
                          onPressed:
                              (_selectedMarker == null) ? null : _changeInfo,
                        ),
                        FlatButton(
                          child: const Text('change info anchor'),
                          onPressed: (_selectedMarker == null)
                              ? null
                              : _changeInfoAnchor,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('change alpha'),
                          onPressed:
                              (_selectedMarker == null) ? null : _changeAlpha,
                        ),
                        FlatButton(
                          child: const Text('change anchor'),
                          onPressed:
                              (_selectedMarker == null) ? null : _changeAnchor,
                        ),
                        FlatButton(
                          child: const Text('toggle draggable'),
                          onPressed: (_selectedMarker == null)
                              ? null
                              : _toggleDraggable,
                        ),
                        FlatButton(
                          child: const Text('toggle flat'),
                          onPressed:
                              (_selectedMarker == null) ? null : _toggleFlat,
                        ),
                        FlatButton(
                          child: const Text('change position'),
                          onPressed: (_selectedMarker == null)
                              ? null
                              : _changePosition,
                        ),
                        FlatButton(
                          child: const Text('change rotation'),
                          onPressed: (_selectedMarker == null)
                              ? null
                              : _changeRotation,
                        ),
                        FlatButton(
                          child: const Text('toggle visible'),
                          onPressed:
                              (_selectedMarker == null) ? null : _toggleVisible,
                        ),
                        FlatButton(
                          child: const Text('change zIndex'),
                          onPressed:
                              (_selectedMarker == null) ? null : _changeZIndex,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),*/
      ],
    );
  }
}
