import 'package:flutter/material.dart';
import 'package:klymbr/network/client.dart';
import 'package:klymbr/view/drawer.dart' show LocalDrawer;
import 'dart:async';
import 'package:klymbr/data.dart';

@visibleForTesting
enum _Access { Free, Occupied, Climbing }

typedef DemoItemBodyBuilder<T> = Widget Function(DemoItem<T> item);
typedef ValueToString<T> = String Function(T value);

class CollapsibleBody extends StatelessWidget {
  const CollapsibleBody(
      {this.margin: EdgeInsets.zero,
      this.child,
      this.onSave,
      this.onCancel,
      this.access});

  final EdgeInsets margin;
  final Widget child;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final _Access access;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    List<Widget> _climb = new List<Widget>();

    if (access == _Access.Free) {
      _climb.add(new Container(
          margin: const EdgeInsets.only(right: 8.0),
          child: new FlatButton(
              onPressed: onSave,
              textTheme: ButtonTextTheme.accent,
              child: const Text('Grimper'))));
    } else if (access == _Access.Climbing) {
      _climb.add(new Container(
          margin: const EdgeInsets.only(right: 8.0),
          child: new FlatButton(
              onPressed: null,
              textTheme: ButtonTextTheme.accent,
              child: const Text('Stop'))));
    }

    _climb.add(new FlatButton(
        onPressed: onCancel,
        child: const Text('Retour',
            style: const TextStyle(
                color: Colors.black54,
                fontSize: 15.0,
                fontWeight: FontWeight.w500))));

    return new Column(children: <Widget>[
      new Container(
          margin: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0) -
              margin,
          child: new Center(
              child: new DefaultTextStyle(
                  style: textTheme.caption.copyWith(fontSize: 15.0),
                  child: child))),
      const Divider(height: 1.0),
      new Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.end, children: _climb))
    ]);
  }
}

class DualHeaderWithHint extends StatelessWidget {
  const DualHeaderWithHint({this.name, this.value, this.hint, this.showHint});

  final String name;
  final String value;
  final String hint;
  final bool showHint;

  Widget _crossFade(Widget first, Widget second, bool isExpanded) {
    return new AnimatedCrossFade(
      firstChild: first,
      secondChild: second,
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return new Row(children: <Widget>[
      new Expanded(
        flex: 2,
        child: new Container(
          margin: const EdgeInsets.only(left: 24.0),
          child: new FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: new Text(
              name,
              style: textTheme.body1.copyWith(fontSize: 15.0),
            ),
          ),
        ),
      ),
      new Expanded(
          flex: 3,
          child: new Container(
              margin: const EdgeInsets.only(left: 24.0),
              child: _crossFade(
                  new Text(value,
                      style: textTheme.caption.copyWith(fontSize: 15.0)),
                  new Text(hint,
                      style: textTheme.caption.copyWith(fontSize: 15.0)),
                  showHint)))
    ]);
  }
}

class DemoItem<T> {
  DemoItem({this.name, this.value, this.hint, this.builder, this.valueToString})
      : textController = new TextEditingController(text: valueToString(value));

  final String name;
  final String hint;
  final TextEditingController textController;
  final DemoItemBodyBuilder<T> builder;
  final ValueToString<T> valueToString;
  T value;
  bool isExpanded = false;

  ExpansionPanelHeaderBuilder get headerBuilder {
    return (BuildContext context, bool isExpanded) {
      return new DualHeaderWithHint(
          name: name,
          value: valueToString(value),
          hint: hint,
          showHint: isExpanded);
    };
  }

  Widget build() => builder(this);
}

class ClimbWays extends StatefulWidget {
  ClimbWays({Key key}) : super(key: key);
  static const String routeName = "/ways";

  @override
  _ClimbWaysState createState() => new _ClimbWaysState();
}

class _ClimbWaysState extends State<ClimbWays> {
  Future<List<DemoItem<dynamic>>> _demoItems;

  Future<List<DemoItem<dynamic>>> get getDemoItem async {
    List<DemoItem<dynamic>> demoItems = new List();
    print("get getDemoItem");
    Connection connectionClient = new Connection();
    connectionClient.token = globalToken;
    print("connection");

    Map<String, dynamic> climbdata = await connectionClient
        .getJson("/rooms/$globalRoom")
        .catchError((exeption) {
      print(showDialog<String>(
          context: context,
          child: new AlertDialog(
              content: new Text("Problèmes\n $exeption"),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context, exeption);
                    })
              ])));
    });

    print("result ${climbdata}");
    print("climbdata $climbdata");
    print("climbdata ${climbdata['paths']}");
    climbdata['paths'].forEach((dynamic data) {
      print("$data\n\n");
    });
    climbdata['paths'].forEach((dynamic data) {

      String wayName = data["name"].toString();
      print(wayName);
      _Access _access = data["free"] == true
          ? _Access.Free
          : data["free"] == false ? _Access.Occupied : _Access.Climbing;
      print("$wayName is $_access");

      demoItems.add(new DemoItem<String>(
        name: "Voie $wayName",
        value: 'Difficulté ' + data["difficulty"].toString(),
        hint: data["free"].toString() == "true" ? "Libre" : "Occupé",
        valueToString: (String value) => value,
        builder: (DemoItem<String> item) {
          void close() {
            setState(() {
              item.isExpanded = false;
            });
          }

          return new Form(
            child: new Builder(
              builder: (BuildContext context) {
                return new CollapsibleBody(
                  access: _access,
                  margin: const EdgeInsets.symmetric(horizontal: 12.0),
                  onSave: () {
                    Form.of(context).save();
                    item.value = "En grimpe sur la voie $wayName";
                    connectionClient.patchRequest(
                        "/rooms/$globalRoom/paths/${data["_id"].toString()}",
                        {"free": false});
                    close();
                  },
                  onCancel: () {
                    Form.of(context).reset();
                    close();
                  },
                  child: new Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                              child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Text('Meilleur Score ' +
                                  data["best"]["time"].toString() +
                                  "s"),
                              const SizedBox(height: 16.0),
                              new Text(data["best"]["firstname"].toString() +
                                  " " +
                                  data["best"]["lastname"].toString()),
                              const SizedBox(height: 16.0),
// pas de date pour le score ?
//                              new Text('Le ' +
//                                  DateTime.parse(
//                                      wdata["bestTime"])
//                                      .toString()),
                            ],
                          )),
                          const SizedBox(width: 16.0),
// pas de score personel
//                          new Expanded(
//                              child: new Column(
//                                  mainAxisAlignment:
//                                      MainAxisAlignment.spaceBetween,
//                                  crossAxisAlignment: CrossAxisAlignment.center,
//                                  children: <Widget>[
//                                new Text('Meilleur Score Personel de ' +
//                                    wdata["personaBestTime"]["time"].toString() +
//                                    "s"),
//                                const SizedBox(height: 16.0),
//                                new Text(
//                                    DateTime.parse(
//                                        wdata["personaBestTime"])
//                                        .toString()),
//                              ])),
                        ],
                      )),
                );
              },
            ),
          );
        },
      ));
    });
    print('return');
    print(demoItems);
    return new Future.value(demoItems);
  }

  @override
  void initState() {
    super.initState();
    _demoItems = getDemoItem;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new LocalDrawer(localRoute: "/ways"),
      appBar: new AppBar(title: const Text("Sélection de voie")),
      body: new SingleChildScrollView(
        child: new Container(
            margin: const EdgeInsets.all(22.0),
            child: new FutureBuilder(
                future: _demoItems,
                builder: (BuildContext context, AsyncSnapshot<List<DemoItem<dynamic>>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return new ExpansionPanelList();
                    case ConnectionState.waiting:
                      return new ExpansionPanelList();
                    case ConnectionState.active:
                      return new ExpansionPanelList();
                    case ConnectionState.done:
                      return new ExpansionPanelList(
                          expansionCallback: (int index, bool isExpended) {
                            setState(() {
                              snapshot.data[index].isExpanded = !isExpended;
                            });
                          },
                          children:
                              snapshot.data.map<ExpansionPanel>((DemoItem<dynamic> item) {
                            return new ExpansionPanel(
                                isExpanded: item.isExpanded,
                                headerBuilder: item.headerBuilder,
                                body: item.build());
                          }).toList());
                  }
                })),
      ),
    );
  }
}
