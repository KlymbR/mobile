import 'package:flutter/material.dart';
import 'package:klymbr/view/view_user.dart';
import 'package:klymbr/view/view_way.dart';
import 'package:klymbr/view/view_map.dart';
import 'package:klymbr/example/contacts_demo.dart';

void main() {
  runApp(new MyApp());
}

class DrawerRoute<T> extends MaterialPageRoute<T> {
  DrawerRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}

class MyApp extends StatelessWidget {
  final String _titleapp = "Klymbr";
  final MaterialColor _colorapp = Colors.blueGrey;
  final Brightness _brightness = Brightness.light;

  DrawerRoute _routeTo(RouteSettings settings) {
    switch (settings.name) {
      case UserView.routeWay:
        return new DrawerRoute(
          builder: (_) => new UserView(),
          settings: settings,
        );
      case ClimbWays.routeName:
        return new DrawerRoute(
          builder: (_) => new ClimbWays(),
          settings: settings,
        );
    }
    assert(false);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: this._titleapp,
      routes: <String, WidgetBuilder>{
        '/b': (BuildContext context) => new ContactsDemo(),
        '/map': (BuildContext context) => new MapView(),
//        '/a': (BuildContext context) => new ,
      },
      theme: new ThemeData(
        primarySwatch: this._colorapp,
        brightness: _brightness,
        platform: Theme.of(context).platform,
      ),
      onGenerateRoute: (RouteSettings settings) => _routeTo(settings),
    );
  }
}
