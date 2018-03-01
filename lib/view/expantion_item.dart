import 'package:flutter/material.dart';

typedef Widget ExpantionItemBodyBuilder<T>(ExpantionItem<T> item);
typedef String ValueToString<T>(T value);

class HeaderWithHint extends StatelessWidget {
  const HeaderWithHint({this.name, this.value, this.expanded});

  final String name;
  final String value;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    print("In header");

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
              child: new Text(value,
                  style: textTheme.caption.copyWith(fontSize: 15.0))))
    ]);
  }
}

class ExpantionItem<T> {
  ExpantionItem({this.name, this.value, this.builder, this.valueToString})
      : textController = new TextEditingController(text: valueToString(value));

  final String name;
  final TextEditingController textController;
  final ExpantionItemBodyBuilder<T> builder;
  final ValueToString<T> valueToString;
  T value;
  bool isExpanded = false;

  ExpansionPanelHeaderBuilder get headerBuilder {
    print("In Expention");
    return (BuildContext context, bool isExpanded) {
      return new HeaderWithHint(
          name: name,
          value: valueToString(value),
          expanded: isExpanded);
    };
  }
}
