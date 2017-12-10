import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:klymbr/view/view_qr.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  static const String routeName = "/login";

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  final bool _scan = true;

  @override
  void initState(){
    super.initState();
    print("in loginview");
    if (_scan)
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(new MaterialPageRoute<Null>(
          // ignore: non_constant_identifier_names
          builder: (BuildContext) {
            return new QrView();
          },
        ));
      });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sign up / Log In"),
      ),
    );
  }
}

