import 'dart:async';
import 'package:flutter/material.dart';
import 'package:klymbr/network/client.dart';
import 'package:klymbr/data.dart';

Future pause(Duration d) => new Future.delayed(d);

/*await pause(const Duration(milliseconds: 100));*/
class _DropdownBt extends StatelessWidget {
  final Map<String, String> rooms;
  final ValueChanged<String> onPressed;
  final String value;

  const _DropdownBt({Key key, this.value, this.rooms, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        hint: Text("Select Room"),
        onChanged: onPressed,
        value: value,
        items: rooms.keys.map((String value) {
          return new DropdownMenuItem<String>(
              value: value, child: new Text(value));
        }).toList());
  }
}

class LocalDrawer extends StatefulWidget {
  LocalDrawer({Key key, this.localRoute}) : super(key: key);
  final String localRoute;

  @override
  _LocalDrawerState createState() => new _LocalDrawerState();
}

class _LocalDrawerState extends State<LocalDrawer> {
  Future<Map<String, String>> _getRoomName;
  bool activateWay;
  static DropdownButton empyDropdowmn = DropdownButton<String>(
      disabledHint: new Text("Loading"), onChanged: null, items: null);

  Future<Map<String, String>> get getRoomName async {
/*    await pause(const Duration(seconds: 5));*/
    Connection connectionClient = new Connection();
    connectionClient.token = globalToken;


    List<dynamic> roomNames =
        await connectionClient.getJsonList("/rooms").catchError((exeption) {
      print(showDialog<String>(
          context: context,
          builder: (BuildContext context) => new AlertDialog(
                  content: new Text("Problèmes\n $exeption"),
                  actions: <Widget>[
                    new FlatButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.pop(context, exeption);
                        })
                  ])));
    });

    Map<String, String> roomName = Map<String, String>();
    roomNames.forEach((elem) {
      roomName[elem["title"]] = elem["_id"];
    });

    return new Future.value(roomName);
  }

  @override
  void initState() {
    super.initState();
    _getRoomName = getRoomName;
    activateWay = globalRoom == null ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: const Text('Bienvenue'),
            accountEmail: const Text('Mon compte'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: const AssetImage(
                'images/daftpunk.jpg',
              ),
            ),
            onDetailsPressed: () {
//              if (widget.localRoute == "/")
//                Navigator.pop(context);
//              else
              Navigator.pushReplacementNamed(context, "/home");
            },
          ),
          new Container(
            padding: const EdgeInsets.only(right: 6.0),
            alignment: Alignment.center,
            child: new FutureBuilder(
                future: _getRoomName,
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, String>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return new Text('Empty');
                    case ConnectionState.waiting:
                      return empyDropdowmn;
                    case ConnectionState.active:
                      return empyDropdowmn;
                    case ConnectionState.done:
                      return _DropdownBt(
                        rooms: snapshot.data,
                        value: roomName,
                        onPressed: (String newValue) {
                          globalRoom = snapshot.data[newValue];
                          setState(() {
                            roomName = newValue;
                            activateWay = true;
                          });
                          print(globalRoom);
                        },
                      );
                  }
                }),
          ),
//          Selection des voies
          new ListTile(
            enabled: activateWay,
            title: const Text('Voies'),
            onTap: () {
              /*/ways*/
              Navigator.pushReplacementNamed(context, "/ways");
            },
          ),
          new ListTile(
//            leading: const Icon(Icons.navigate_next),
            title: const Text('Localisation des salles de sports'),
            onTap: () {
              Navigator.popAndPushNamed(context, "/map");
            },
          ),
          new ListTile(

//            leading: const Icon(Icons.navigate_next),
            title: const Text('Déconnection'),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/");
            },
          ),
//        Différentes données affichées dans l'app :
//        nombre de voies grimpées, amis, difficulté moyenne,
//        temps passé dans la salle, dates et heures des entrées/sorties de la salle,
//        date de validité de la carte, salles de sports auxquelles l'utilisateur a accès

//          new ListTile(
//            title: const Text('Stats'),
//            onTap: () {
//              Navigator.pushNamed(context, "/stats");
//            },
//          ),

//          Score Personel par voie
//          Best Scores par voie

//          new ListTile(
//            title: const Text('Scan'),
//            onTap: () {
////              Connection connectionClient = new Connection(
////                  Uri.encodeFull('https://api.ipify.org?format=json'));
////              Map<String, dynamic> response = await connectionClient.getJson();
////              print(response.toString());
////                DataUser user = new DataUser.fromJson(response);
//
//              DataUser user =
//                  new DataUser.fromJson(JSON.decode(serverdata));
//
//              Address address = new Address.fromJson((JSON.decode(personaldata)
//                  as Map<String, dynamic>)["address"]);
//
//              Iterable<Licences> licences = (JSON.decode(personaldata)
//                      as Map<String, dynamic>)["licences"]
//                  .map((Map<String, dynamic> data) =>
//                      new Licences.fromJson(data));
//
////              print(licences);
//              print("user avant ecriture");
////              print(address.toJson());
////              print(user.toJson());
//
//              new Storage("userlicences")
//                ..write(licences
//                    .map((Licences licence) => licence.toJson())
//                    .toList())
//                ..readListJson().then((List<Map<String, dynamic>> info) {
//                  print("Info list after read $info");
//                  print(info.map((Map<String, dynamic> data) =>
//                      new Licences.fromJson(data)));
//                });
//
//              new Storage("userdata")
//                ..writeJson(user)
//                ..readJson().then((Map info) {
//                  print("lecture du json");
//                  print(info.toString());
//                  print(new DataUser.fromJson(info));
//                });
//              new Storage("useraddress")
//                ..writeJson(address)
//                ..readJson().then((Map info) {
//                  print(info.toString());
//                  print(new Address.fromJson(info));
//                });
//
//              new QRCodeReader()
//                  .setAutoFocusIntervalInMs(200)
//                  .setForceAutoFocus(true)
//                  .setTorchEnabled(true)
//                  .setHandlePermissions(true)
//                  .setExecuteAfterPermissionGranted(true)
//                  .scan().then((String url) async {
//              });
//            },
//          )
        ],
      ),
    );
  }
}
