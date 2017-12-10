import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klymbr/view/drawer.dart' show LocalDrawer;
import 'package:klymbr/models/data.dart' show DataUser;
import 'package:klymbr/models/fileio.dart' show Storage;
import 'package:klymbr/network/client.dart' show Connection;
import 'package:intl/intl.dart';

class UserView extends StatefulWidget {
  UserView({Key key}) : super(key: key);

  static const String routeBody = "/";

  @override
  _UserViewState createState() => new _UserViewState();
}

class _UserViewState extends State<UserView> {
  Map _value;

  @override
  void initState() {
    super.initState();

//    Internet Data
//    new Connection().getJson("licenceUser").then((Map value) {
//      this._value = value;
//    });
//    Local data
//    new Storage(fileDb[0]).readJson().then((Map value) {
//      this._value = value;
//    });

    print("Utilisateur Json : ");
    print(this._value);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new LocalDrawer(localRoute: "/"),
      appBar: new AppBar(
        title: new Text("Mon compte"),
      ),
      body: new _UserFormField(userMap: _value),
    );
  }
}

class _UserFormField extends StatefulWidget {
  _UserFormField({Key key, this.userMap}) : super(key: key);
  final Map userMap;

  @override
  __UserFormFieldState createState() => new __UserFormFieldState();
}

class __UserFormFieldState extends State<_UserFormField> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _FrNumberTextInputFormatter _phoneNumberFormatter =
      new _FrNumberTextInputFormatter();

  DataUser _user;
  bool _autovalidate = false;
  bool _formWasEdited = false;

  @override
  void initState() {
    super.initState();
    if (widget.userMap == null) {
      _user = new DataUser();
      print("befor push");
    } else {
      _user = new DataUser.fromJson(widget.userMap);
    }
    print("Utilisateur : ");
    print(_user.toJson());
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Merci de vous relire.');
    } else {
      form.save();
      print(_user);
      showInSnackBar('${_user.name}\'s phone number is ${_user.phoneNumber}');
    }
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return "Merci d'entrer un prenom et un nom";
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Seule les caractères alphabetique sont autorisé';
    return null;
  }

  String _validateLicence(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return "Merci d'enregistre votre licence";
    final RegExp nameExp = new RegExp(r'^[A-Za-z0-9]+$');
    if (!nameExp.hasMatch(value))
      return 'Seule les caractères alphanumérique sont autorisé';
    return null;
  }

  String _validatePhoneNumber(String value) {
    _formWasEdited = true;
    final RegExp phoneExp = new RegExp(r'^\d-\d\d-\d\d-\d\d-\d\d$');
    if (!phoneExp.hasMatch(value))
      return "+33 #-##-##-##-## - Merci d'entré un telephone valid.";
    return null;
  }

  Future<bool> _warnUserAboutInvalidData() async {
    final FormState form = _formKey.currentState;
    if (form == null || !_formWasEdited || form.validate()) return true;

    return await showDialog<bool>(
          context: context,
          child: new AlertDialog(
            title: const Text('This form has errors'),
            content: const Text('Really leave this form?'),
            actions: <Widget>[
              new FlatButton(
                child: const Text('YES'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              new FlatButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
      key: _formKey,
      autovalidate: _autovalidate,
      onWillPop: _warnUserAboutInvalidData,
      child: new ListView(
        padding: const EdgeInsets.only(right: 12.0),
        children: <Widget>[
          new Image.asset(
            'images/user.jpg',
            width: 600.0,
            height: 240.0,
            fit: BoxFit.cover,
          ),
          new Container(
//                padding: const EdgeInsets.all(20.0),
            alignment: Alignment.center,
            child: new DropdownButton<String>(
              value: _user.sex,
              onChanged: (String newValue) {
                setState(() {
                  _user.sex = newValue;
                });
              },
              items: <String>["Monsieur", "Madame"].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
            ),
          ),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                child: new TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: "Comment tu t'appel",
                    labelText: 'Nom *',
                  ),
                  onSaved: (String value) {
                    _user.name = value;
                  },
                  validator: _validateName,
                ),
              ),
              const SizedBox(width: 16.0),
              new Expanded(
                child: new TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Comment tu t'appel",
                    labelText: 'Prenom *',
                  ),
                  onSaved: (String value) {
                    _user.firstName = value;
                  },
                  validator: _validateName,
                ),
              ),
            ],
          ),
          new _DateTimePicker(
//            icon: const Icon(Icons.confirmation_number),
            labelText: 'Date de naissance',
            selectedDate: _user.birthday,
            selectDate: (DateTime date) {
              setState(() {
//                _birthDate = date;
                _user.birthday = date;
                print(date.toString());
              });
            },
          ),
          new TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.confirmation_number),
              prefixText: 'N°',
              hintText: "Licence",
              labelText: 'Licence *',
              prefixStyle: const TextStyle(color: Colors.red),
              suffixStyle: const TextStyle(color: Colors.red),
            ),
            maxLines: 1,
            onSaved: (String value) {
              _user.licenceNbr = value;
            },
            validator: _validateLicence,
          ),
          new TextFormField(
            decoration: const InputDecoration(
                icon: const Icon(Icons.phone),
                hintText: 'Where can we reach you?',
                labelText: 'Phone Number *',
                prefixText: '+33'),
            keyboardType: TextInputType.phone,
            onSaved: (String value) {
              _user.phoneNumber = value;
            },
            validator: _validatePhoneNumber,
            // TextInputFormatters are applied in sequence.
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
              // Fit the validating format.
              _phoneNumberFormatter,
            ],
          ),
          new Container(
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.center,
            child: new Column(
              children: <Widget>[
                new RaisedButton(
                  child: const Text('SUBMIT'),
                  onPressed: _handleSubmitted,
                ),
                const SizedBox(height: 16.0),
                new RaisedButton(
                  child: const Text('SCAN'),
                  onPressed: (){
                    Navigator.pushNamed(context, "/login");
                    },
                )
              ],
            ),
          ),
          new Container(
            padding: const EdgeInsets.only(top: 20.0),
            child: new Text('* champ obligatoire',
                style: Theme.of(context).textTheme.caption),
          ),
        ],
      ),
    );
  }
}

/// Format incoming numeric text to fit the format of (###) ###-#### ##...
class _FrNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength > 1) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 1) + "-");
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength > 3) {
      newText.write(newValue.text.substring(1, usedSubstringIndex = 3) + "-");
      if (newValue.selection.end >= 3) selectionIndex++;
    }
    if (newTextLength > 5) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 5) + "-");
      if (newValue.selection.end >= 5) selectionIndex++;
    }
    if (newTextLength > 7) {
      newText.write(newValue.text.substring(5, usedSubstringIndex = 7) + "-");
      if (newValue.selection.end >= 7) selectionIndex++;
    }
    if (newTextLength > 9) {
      newValue.text.substring(9, selectionIndex);
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
  })
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        locale: const Locale('fr', 'FR'),
        initialDate: selectedDate,
        firstDate: new DateTime(1800, 1),
        lastDate: new DateTime(2042));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          flex: 4,
          child: new _InputDropdown(
            icon: new Icon(Icons.date_range),
            labelText: labelText,
            valueText: new DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed,
      this.icon})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          icon: icon,
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}
