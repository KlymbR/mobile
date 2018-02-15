import 'package:flutter/material.dart';
import 'package:klymbr/network/client.dart';
import 'package:klymbr/models/data.dart' show DataUser;
import 'package:klymbr/models/fileio.dart' show Storage;
import 'package:klymbr/data.dart' show personaldata;
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
            onDetailsPressed: (){
//              if (widget.localRoute == "/")
//                Navigator.pop(context);
//              else
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
            onTap: () {},
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

              DataUser user = new DataUser.fromWebJson(JSON.decode(personaldata));
              print(user.toJson());
              Storage st =  new Storage("userdata");
              st.writeJson(user);
              st.readJson().then((Map info) {
                print(info.toString());
                print(new DataUser.fromJson(info));
              });


//              new QRCodeReader()
//                  .setAutoFocusIntervalInMs(200)
//                  .setForceAutoFocus(true)
//                  .setTorchEnabled(true)
//                  .setHandlePermissions(true)
//                  .setExecuteAfterPermissionGranted(true)
//                  .scan().then((String url) async {
//              });
            },
          )
        ],
      ),
    );
  }
}
