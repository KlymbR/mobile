import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:klymbr/network/client.dart';
import 'package:qrcode_reader/QRCodeReader.dart' show QRCodeReader;
import 'package:klymbr/data.dart' show tokenGlobal, serverdata;
import 'package:klymbr/models/data.dart' show DataUser, Address, Licences;
import 'package:klymbr/models/fileio.dart' show Storage;

class LoginPage extends StatefulWidget {
  static const String routename = "/";

  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;
  TextEditingController _password = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  Widget _icon = const Icon(FontAwesomeIcons.signInAlt);

  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.bounceOut,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new ListView(
          //fit: StackFit.expand,
          children: <Widget>[
            new Theme(
              data: new ThemeData(
                  brightness: Brightness.light,
                  inputDecorationTheme: new InputDecorationTheme(
                    hintStyle:
                        new TextStyle(color: Colors.blue, fontSize: 20.0),
                    labelStyle:
                        new TextStyle(color: Colors.tealAccent, fontSize: 25.0),
                  )),
              isMaterialAppTheme: true,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                  ),
                  new FlutterLogo(
                    size: _iconAnimation.value * 140.0,
                  ),
                  new Container(
                    padding: const EdgeInsets.all(40.0),
                    child: new Form(
                      autovalidate: true,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new TextFormField(
                            decoration: new InputDecoration(
                                labelText: "Enter Email",
                                fillColor: Colors.white),
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          new TextFormField(
                            decoration: new InputDecoration(
                              labelText: "Enter Password",
                            ),
                            controller: _password,
                            obscureText: true,
                            keyboardType: TextInputType.text,
                          ),
                          new Padding(
                            padding: const EdgeInsets.only(top: 60.0),
                          ),
                          new MaterialButton(
                            height: 50.0,
                            minWidth: 150.0,
                            color: Colors.blueGrey,
                            splashColor: Colors.teal,
                            textColor: Colors.white,
                            child: new Icon(Icons.camera),
                            onPressed: () {
                              new QRCodeReader()
                                  .setAutoFocusIntervalInMs(200)
                                  .setForceAutoFocus(true)
                                  .setTorchEnabled(true)
                                  .setHandlePermissions(true)
                                  .setExecuteAfterPermissionGranted(true)
                                  .scan()
                                  .then((String url) async {
                                setState(() => _email.text = url);
                              });
                            },
                          ),
                          const SizedBox(height: 16.0),
                          new MaterialButton(
                            height: 50.0,
                            minWidth: 150.0,
                            color: Colors.green,
                            splashColor: Colors.teal,
                            textColor: Colors.white,
                            child: _icon,
                            onPressed: () {

                              if (_email.text != "" || _password.text != "") {
                                print("${_email.text} ${_password.text}");
                                setState(() {
//                                _icon = new Icon(FontAwesomeIcons.signInAlt);
                                  _icon = const CircularProgressIndicator();
                                });

//                                Map<String, dynamic> value = JSON.decode(serverdata);

                                Connection connectionClient = new Connection();
                                connectionClient.postRequest("/auth/sign_in/", {
                                  "email": _email.text,
                                  "password": _password.text
                                }).then((Map<String, dynamic> value) {
                                  print(value);
                                  tokenGlobal = value["token"];
                                  connectionClient.token = tokenGlobal;

                                  connectionClient
                                      .getJson("/user/")
                                      .then((Map<String, dynamic> value) {
                                    DataUser user =
                                        new DataUser.fromJson(value["result"]);
                                    print("user = $user");
                                    Address address = new Address.fromJson(
                                        value["result"]["address"]);
                                    print("address = $address");
                                    print(
                                        "value[\"result\"][\"licenses\"] = ${value["result"]
                                        ["licenses"]}");
                                    Iterable<Licences> licences =
                                        value["result"]["licenses"].map(
                                            (Map<String, dynamic> data) =>
                                                new Licences.fromJson(data));
                                    print("test");
                                    print("licences = $licences");
                                    print("test 2");
                                    new Storage("userlicences")
                                      ..write(licences
                                          .map((Licences licence) =>
                                              licence.toJson())
                                          .toList())
                                      ..readListJson().then(
                                          (List<Map<String, dynamic>> info) {
                                        print("Info list after read $info");
                                        print(info.map(
                                            (Map<String, dynamic> data) =>
                                                new Licences.fromJson(data)));
                                      });

                                    new Storage("userdata")
                                      ..writeJson(user)
                                      ..readJson().then((Map info) {
                                        print("lecture du json");
                                        print(info.toString());
                                        print(new DataUser.fromJson(info));
                                      });
                                    new Storage("useraddress")
                                      ..writeJson(address)
                                      ..readJson().then((Map info) {
                                        print(info.toString());
                                        print(new Address.fromJson(info));
                                      });

                                    if (tokenGlobal != null) {
                                      Navigator.pushNamed(context, "/home");
                                    }
                                  });


                                });

//                              Connection connectionClient = new Connection(
//                                  Uri.encodeFull(
//                                      'https://api.ipify.org?format=json'));
//                              Map<String,
//                                  dynamic> response = await connectionClient
//                                  .getJson();
//                              print(response.toString());
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]),
    );
  }
}
