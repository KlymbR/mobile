import 'dart:async';
import 'package:flutter/material.dart';
import 'package:klymbr/data.dart';
import 'package:klymbr/network/client.dart';
import 'package:map_view/map_view.dart' as GMapView;

const String API_KEY = "AIzaSyBxKRmMLmwEd3mP7A6378oCgNBiBFyiYr4";

class CompositeSubscription {
  Set<StreamSubscription> _subscriptions = new Set();

  void cancel() {
    for (var n in this._subscriptions) {
      n.cancel();
    }
    this._subscriptions = new Set();
  }

  void add(StreamSubscription subscription) {
    this._subscriptions.add(subscription);
  }

  void addAll(Iterable<StreamSubscription> subs) {
    _subscriptions.addAll(subs);
  }

  bool remove(StreamSubscription subscription) {
    return this._subscriptions.remove(subscription);
  }

  bool contains(StreamSubscription subscription) {
    return this._subscriptions.contains(subscription);
  }

  List<StreamSubscription> toList() {
    return this._subscriptions.toList();
  }
}

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => new _MapViewState();
}

// add map code

class _MapViewState extends State<MapView> {
  GMapView.MapView mapView = new GMapView.MapView();

  GMapView.CameraPosition cameraPosition;
  CompositeSubscription compositeSubscription = new CompositeSubscription();
  var staticMapProvider = new GMapView.StaticMapProvider(API_KEY);
  Uri staticMapUri;
  List<Widget> title = new List();
  List<GMapView.Marker> maker = new List();

  showMap() {
    mapView.show(
        new GMapView.MapOptions(
            mapViewType: GMapView.MapViewType.normal,
            showUserLocation: true,
            initialCameraPosition: new GMapView.CameraPosition(
                new GMapView.Location(48.8534, 2.3488), 12.0),
            title: "Trouver une salle de sport"),
        toolbarActions: [new GMapView.ToolbarAction("Close", 1)]);

    StreamSubscription sub = mapView.onMapReady.listen((_) {
      mapView.setMarkers(maker);
    });

    compositeSubscription.add(sub);
    sub = mapView.onLocationUpdated
        .listen((location) => print("Location updated $location"));
    compositeSubscription.add(sub);

    sub = mapView.onTouchAnnotation
        .listen((annotation) => print("$annotation annotation tapped"));
    compositeSubscription.add(sub);

    sub = mapView.onMapTapped
        .listen((location) => print("Touched location $location"));
    compositeSubscription.add(sub);

    sub = mapView.onCameraChanged.listen((cameraPosition) =>
        this.setState(() => this.cameraPosition = cameraPosition));
    compositeSubscription.add(sub);
    sub = mapView.onToolbarAction.listen((id) {
      if (id == 1) {
        _handleDismiss();
      }
    });
    compositeSubscription.add(sub);

    sub = mapView.onInfoWindowTapped.listen((marker) {
      print("Info Window Tapped for ${marker.title}");
    });
    compositeSubscription.add(sub);
  }

  _handleDismiss() async {
    double zoomLevel = await mapView.zoomLevel;
    GMapView.Location centerLocation = await mapView.centerLocation;
    List<GMapView.Marker> visibleAnnotations = await mapView.visibleAnnotations;
    print("Zoom Level: $zoomLevel");
    print("Center: $centerLocation");
    print("Visible Annotation Count: ${visibleAnnotations.length}");
    var uri = await staticMapProvider.getImageUriFromMap(mapView,
        width: 900, height: 400);
    setState(() => staticMapUri = uri);
    mapView.dismiss();
    compositeSubscription.cancel();
  }

  @override
  initState() {
    print("map connection");
    GMapView.MapView.setApiKey(API_KEY);
    Connection connectionClient = new Connection();
    connectionClient.token = tokenGlobal;
    connectionClient
        .getJson("/climbingRoom/")
        .then((Map<String, dynamic> data) {
      data["result"].forEach((dynamic climb) {
        title.add(new ListTile(
          leading: const Icon(Icons.map),
          title: new Text(climb["title"].toString()),
        ));
        print("${climb["latitude"]} ${climb["latitude"].runtimeType}");
        maker.add(new GMapView.Marker(climb["_id"], climb["title"],
            climb["latitude"].toDouble(), climb["longitude"].toDouble()));
      });
    })
        .catchError((exeption) {
      print(showDialog<String>(
          context: context,
          child: new AlertDialog(
              content:
              new Text("Problèmes\n serveur"),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, "/home");
                    })
              ])));
    });;
    super.initState();

    staticMapUri = staticMapProvider.getStaticUri(
        new GMapView.Location(48.8534, 2.3488), 12,
        width: 900, height: 400);

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Map"),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            height: 250.0,
            child: new Stack(
              children: <Widget>[
                new Center(
                    child: new Container(
                  child: new Text(
                    "You are supposed to see a map here.\n\nNo internet connection\n\n",
                    textAlign: TextAlign.center,
                  ),
                  padding: const EdgeInsets.all(20.0),
                )),
                new InkWell(
                  child: new Center(
                    child: new Image.network(staticMapUri.toString()),
                  ),
                  onTap: showMap,
                )
              ],
            ),
          ),
          new Expanded(
              child: new CustomScrollView(
            shrinkWrap: true,
            slivers: <Widget>[
              new SliverPadding(
                padding: const EdgeInsets.all(20.0),
                sliver: new SliverList(
                  delegate: new SliverChildListDelegate(title),
                ),
              ),
            ],
          )),

//          new ListView(
//            shrinkWrap: true,
//            padding: const EdgeInsets.all(20.0),
//            children: <Widget>[
//              ,
//            ],
//          )
        ],
      ),
    );
  }
}
