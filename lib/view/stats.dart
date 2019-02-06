import 'package:flutter/material.dart';
import 'package:klymbr/view/drawer.dart' show LocalDrawer;
import 'simple.dart';

class StatsView extends StatefulWidget {
  static const String routeWay = "/stats";

  @override
  _StatsViewState createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new LocalDrawer(localRoute: "/"),
      appBar: new AppBar(
        title: new Text("Mon compte"),
      ),
      body: new _StatsView(),
    );
  }
}

class _StatsView extends StatefulWidget {
  @override
  __StatsViewState createState() => __StatsViewState();
}

class __StatsViewState extends State<_StatsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          new SizedBox(height: 250.0,
              child: new SimpleTimeSeriesChart.withUserData('altitude')),
          new SizedBox(height: 250.0,
              child: new SimpleTimeSeriesChart.withUserData("freq")),
        ],
      ),
    );
  }
}

