import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Connection {
  static final _headers = {"Content-Type": "application/json"};
  static const _Url = "www.klymbr.com/api"; // URL to web API
  final httpClient = createHttpClient();

  Connection();

  dynamic _extractData(Response resp) => JSON.decode(resp.body)["data"];

  Exception _handleError(dynamic e) {
    return new Exception('Server error; cause: $e');
  }

  Future<Map> getJson(String _args) async {
    try {
      final response = await httpClient.get("$_Url/$_args");
      return _extractData(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
}






void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _ipAddress = 'Unknown';

  _getIPAddress() async {
    String url = 'https://httpbin.org/ip';
    var httpClient = createHttpClient();
    var response = await httpClient.read(url);
    Map data = JSON.decode(response);
    String ip = data['origin'];

    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    if (!mounted) return;

    setState(() {
      _ipAddress = ip;
    });
  }

  @override
  Widget build(BuildContext context) {
    var spacer = new SizedBox(height: 32.0);

    return new Scaffold(
      body: new Center(
        child: new Column(
          children: <Widget>[
            spacer,
            new Text('Your current IP address is:'),
            new Text('$_ipAddress.'),
            spacer,
            new RaisedButton(
              onPressed: _getIPAddress,
              child: new Text('Get IP address'),
            ),
          ],
        ),
      ),
    );
  }
}
