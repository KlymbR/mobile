import 'dart:async';
import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart' as GMapView;

const String API_KEY = "";

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
  GMapView.MapView mapView = new GMapView.MapView() ;
  GMapView.CameraPosition cameraPosition;
  var compositeSubscription = new CompositeSubscription();
  var staticMapProvider = new GMapView.StaticMapProvider(API_KEY);
  Uri staticMapUri;


  showMap() {
    mapView.show(
        new GMapView.MapOptions(
            mapViewType: GMapView.MapViewType.normal,
            showUserLocation: true,
            initialCameraPosition: new GMapView.CameraPosition(
                new GMapView.Location(48.8534, 2.3488), 14.0),
            title: "Trouver une salle de sport"),
        toolbarActions: [new GMapView.ToolbarAction("Close", 1)]
    );

    var sub = mapView.onMapReady.listen((_) {
      mapView.setMarkers(<GMapView.Marker>[
        new GMapView.Marker("1", "Number 1", 48.8534, 2.3488, color: Colors.blue),
        new GMapView.Marker("2", "Number 2", 48.842886, 2.357254),
      ]);
      mapView.addMarker(new GMapView.Marker("3", "Number 3", 48.808811, 2.357986,
          color: Colors.purple));

      mapView.zoomToFit(padding: 100);
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
    GMapView.MapView.setApiKey(API_KEY);
    super.initState();
    cameraPosition = new GMapView.CameraPosition(new GMapView.Location(48.8534, 2.3488), 12.0);
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
          new Expanded(child:
          new CustomScrollView(
            shrinkWrap: true,
            slivers: <Widget>[
              new SliverPadding(
                padding: const EdgeInsets.all(20.0),
                sliver: new SliverList(
                  delegate: new SliverChildListDelegate(
                    <Widget>[
                      new ListTile(
                        leading: const Icon(Icons.map),
                        title: const Text('Adresse numero 1'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.map),
                        title: const Text('Adresse numero 2'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.map),
                        title: const Text('Adresse numero 3'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.map),
                        title: const Text('Adresse numero 4'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.map),
                        title: const Text('Adresse numero 5'),
                      ),
                    ],
                  ),
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
