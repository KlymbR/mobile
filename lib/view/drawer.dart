import 'package:flutter/material.dart';
import 'package:klymbr/models/data.dart' show DataUser, Address, Licences;
import 'package:klymbr/models/fileio.dart' show Storage;
import 'package:klymbr/data.dart' show personaldata, serverdata;
import 'package:qrcode_reader/QRCodeReader.dart';
import 'dart:convert';

class LocalDrawer extends StatefulWidget {
  LocalDrawer({Key key, this.localRoute}) : super(key: key);
  final String localRoute;

  @override
  _LocalDrawerState createState() => new _LocalDrawerState();
}

class _LocalDrawerState extends State<LocalDrawer> {
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
          new ListTile(
//            leading: const Icon(Icons.navigate_next),
            title: const Text('Déconnection'),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/");
            },
          ),
          new ListTile(
//            leading: const Icon(Icons.navigate_next),
            title: const Text('Localisation des salles de sports'),
            onTap: () {
              Navigator.popAndPushNamed(context, "/map");
            },
          ),
//          Selection des voies
          new ListTile(
            title: const Text('Voies'),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/ways");
            },
          ),
//        Différentes données affichées dans l'app :
//        nombre de voies grimpées, amis, difficulté moyenne,
//        temps passé dans la salle, dates et heures des entrées/sorties de la salle,
//        date de validité de la carte, salles de sports auxquelles l'utilisateur a accès
          new ListTile(
            title: const Text('Stats'),
            onTap: () {
              Navigator.pushNamed(context, "/stats");
            },
          ),
//          Score Personel par voie
//          Best Scores par voie

          new ListTile(
            title: const Text('Scan'),
            onTap: () {
//              Connection connectionClient = new Connection(
//                  Uri.encodeFull('https://api.ipify.org?format=json'));
//              Map<String, dynamic> response = await connectionClient.getJson();
//              print(response.toString());
//                DataUser user = new DataUser.fromJson(response);

              DataUser user =
                  new DataUser.fromJson(JSON.decode(serverdata));
              
              Address address = new Address.fromJson((JSON.decode(personaldata)
                  as Map<String, dynamic>)["address"]);

              Iterable<Licences> licences = (JSON.decode(personaldata)
                      as Map<String, dynamic>)["licences"]
                  .map((Map<String, dynamic> data) =>
                      new Licences.fromJson(data));

//              print(licences);
              print("user avant ecriture");
//              print(address.toJson());
//              print(user.toJson());

              new Storage("userlicences")
                ..write(licences
                    .map((Licences licence) => licence.toJson())
                    .toList())
                ..readListJson().then((List<Map<String, dynamic>> info) {
                  print("Info list after read $info");
                  print(info.map((Map<String, dynamic> data) =>
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

              new QRCodeReader()
                  .setAutoFocusIntervalInMs(200)
                  .setForceAutoFocus(true)
                  .setTorchEnabled(true)
                  .setHandlePermissions(true)
                  .setExecuteAfterPermissionGranted(true)
                  .scan().then((String url) async {
              });
            },
          )
        ],
      ),
    );
  }
}
