import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:klymbr/network/client.dart';
import 'package:klymbr/data.dart' show globalToken, serverdata;
import 'package:klymbr/models/data.dart' show DataUser, Address, Licences;
import 'package:klymbr/models/fileio.dart' show Storage;
import 'package:flutter_svg/flutter_svg.dart';

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
        vsync: this, duration: new Duration(milliseconds: 1000));
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
                  new Image.asset(
                    'images/LogoEIP-01.png',
                    width: _iconAnimation.value * 250.0,
                    height:_iconAnimation.value * 210.0,
                  ),
/*                  new FlutterLogo(
                    size: _iconAnimation.value * 140.0,
                  ),*/
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
//                          new MaterialButton(
//                            height: 50.0,
//                            minWidth: 150.0,
//                            color: Colors.blueGrey,
//                            splashColor: Colors.teal,
//                            textColor: Colors.white,
//                            child: new Icon(Icons.camera),
//                            onPressed: () {
//                              new QRCodeReader()
//                                  .setAutoFocusIntervalInMs(200)
//                                  .setForceAutoFocus(true)
//                                  .setTorchEnabled(true)
//                                  .setHandlePermissions(true)
//                                  .setExecuteAfterPermissionGranted(true)
//                                  .scan()
//                                  .then((String url) async {
//                                setState(() => _email.text = url);
//                              });
//                            },
//                          ),
                          const SizedBox(height: 16.0),
                          new MaterialButton(
                            height: 50.0,
                            minWidth: 150.0,
                            color: Colors.green,
                            splashColor: Colors.teal,
                            textColor: Colors.white,
                            child: _icon,
                            onPressed: () {
                              _email.text = "adocquin@outlook.com";
                              _password.text = "toto";
                              if (_email.text != "" || _password.text != "") {
                                print("${_email.text} ${_password.text}");
                                setState(() {
//                                _icon = new Icon(FontAwesomeIcons.signInAlt);
                                  _icon = const CircularProgressIndicator();
                                });

//                                Map<String, dynamic> value = JSON.decode(serverdata);

                                Connection connectionClient = new Connection();
//
                                connectionClient.postRequest("/users/authenticate", {
                                  "email": _email.text,
                                  "password": _password.text
                                }).then((Map<String, dynamic> value) {
                                  print("then");
                                  print(value);
                                  globalToken = value["token"];
                                  print("the token");
                                  print(globalToken);
                                  connectionClient.token = globalToken;
                                  print(value["user"]);
                                  DataUser user =
                                  new DataUser.fromJson(value["user"]);
                                  print("user = $user");
                                  Address address = new Address.fromJson(
                                      value["user"]["address"]);
                                  print("address = $address");
                                  print(
                                      "value[\"user\"][\"licenses\"] = ${value["user"]["licenses"]}");
                                  List licences =
                                  value["user"]["licenses"].map((data) {
                                    return new Licences.fromJson(data);
                                  }).toList();
                                  print("test");
                                  print("licences = $licences");
                                  print("test 2");
                                  new Storage("userlicences")
                                    ..write(licences
                                        .map((licence) => licence.toJson())
                                        .toList())
                                    ..readListJson().then(
                                            (List<dynamic> info) {
                                          print("Info list after read $info");
                                          print(info.map(
                                                  (data) =>
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

                                  if (globalToken != null) {
                                    Navigator.pushReplacementNamed(
                                        context, "/home");
                                  }
                                }).catchError((exeption) {
                                  print(showDialog<String>(
                                      context: context,
                                      child: new AlertDialog(
                                          content:
                                              new Text("Problèmes\n $exeption"),
                                          actions: <Widget>[
                                            new FlatButton(
                                                child: const Text('OK'),
                                                onPressed: () {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context, "/");
                                                  _icon = const Icon(
                                                      FontAwesomeIcons
                                                          .signInAlt);
                                                })
                                          ])));
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
