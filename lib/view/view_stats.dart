import 'package:flutter/material.dart';
import 'package:klymbr/view/drawer.dart' show LocalDrawer;
import 'dart:async';

class Stats extends StatefulWidget {
  Stats({Key key}) : super(key: key);

  static const String routename = "/stats";

  @override
  _StatsState createState() => new _StatsState();
}

class _StatsState extends State<Stats> {
  Stream<int> _time;

  Stream<int> timedCounter(Duration interval, int maxCount) {
    StreamController<int> controller;
    Timer timer;
    int counter = 0;

    void tick(_) { // ignore: non_constant_identifier_names
      counter++;
      controller.add(counter); // Ask stream to send counter values as event.
      if (maxCount != null && counter >= maxCount) {
        timer.cancel();
        controller.close();    // Ask stream to shut down and tell listeners.
      }
    }

    void startTimer() {
      timer = new Timer.periodic(interval, tick);
    }

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
      }
    }

    controller = new StreamController<int>(
        onListen: startTimer,
        onPause: stopTimer,
        onResume: startTimer,
        onCancel: stopTimer);

    return controller.stream;
  }

  @override
  void initState() {
    super.initState();
    _time = timedCounter(const Duration(seconds: 1), 15).map((int x) => x * 2);

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new LocalDrawer(localRoute: "/stats"),
      appBar: new AppBar(title: const Text("Informations de grimpe")),
      body: new Container(
          child: new ListView(
            children: <Widget>[
              new Center(child: new StreamBuilder<int>(
                stream: _time, // a Stream<int> or null
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.none: return new Text('Erreur pas de données');
                    case ConnectionState.waiting: return new Text('Awaiting ...');
                    case ConnectionState.active: return new Text('${snapshot.data}');
                    case ConnectionState.done: return new Text('${snapshot.data} (closed)');
                    default: throw "Unknown: ${snapshot.connectionState}";
                  }
                },
              ))
            ],
          ),
      ),
    );
  }
}
