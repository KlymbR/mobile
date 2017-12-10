import 'package:flutter/material.dart';
import 'package:klymbr/view/drawer.dart' show LocalDrawer;

class ClimbWays extends StatefulWidget {
  ClimbWays({Key key}) : super(key: key);

  static const String routeName = "/ways";

  @override
  _ClimbWaysState createState() => new _ClimbWaysState();
}

class _ClimbWaysState extends State<ClimbWays> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new LocalDrawer(localRoute: "/ways"),
      appBar: new AppBar(title: new Text("Sélection de voie")),
      body: new Container(),
    );
  }
}
