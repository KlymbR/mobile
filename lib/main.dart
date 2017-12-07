import 'package:flutter/material.dart';
import 'view/userView.dart';
import 'package:klymbr/view/loginview.dart';
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
      case UserView.routeBody:
        return new DrawerRoute(
          builder: (_) => new UserView(),
          settings: settings,
        );
      case LoginPage.routeBody:
        return new DrawerRoute(
          builder: (_) => new LoginPage(),
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
        '/a': (BuildContext context) => new ContactsDemo(),
        '/b': (BuildContext context) => new ContactsDemo(),
        '/c': (BuildContext context) => new ContactsDemo(),
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
