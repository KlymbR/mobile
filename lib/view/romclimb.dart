import 'package:flutter/material.dart';

class RommClimb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: new Icon(Icons.accessible, size: 150.0, color: Colors.blue),
      ),
    );
  }
}

class Lol extends StatefulWidget {
  @override
  _LolState createState() => new _LolState();
}

class _LolState extends State<Lol> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Text(
            'You have pushed the button this many times:',
          ),
          new Text(
            "B !",
          ),
        ],
      ),
    );
  }
}
