import 'package:flutter/material.dart';

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
          new DrawerHeader(
              child: new GestureDetector(
            onTap: () {
              if (widget.localRoute == "/")
                Navigator.pop(context);
              else
                Navigator.pushReplacementNamed(context, "/");
            },
            child: new Container(
              child: const Text('Mon Compte'),
            ),
          )),
          new ListTile(
            leading: const Icon(Icons.navigate_next),
            title: const Text('Localisation des salles de sports'),
            onTap: () {
              Navigator.popAndPushNamed(context, "/map");
            },
          ),
//          Différentes données affichées dans l'app :
// nombre de voies grimpées, amis, difficulté moyenne,
// temps passé dans la salle, dates et heures des entrées/sorties de la salle,
// date de validité de la carte, salles de sports auxquelles l'utilisateur a accès
          new ListTile(
            title: const Text('Stats'),
            onTap: () {},
          ),
//          Score Personel par voie
//          Best Scores par voie
          new ListTile(
            title: const Text('Voies'),
            onTap: () {},
          ),
          new ListTile(
            title: const Text('Carte des salles de sport'),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
