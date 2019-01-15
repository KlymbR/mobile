import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klymbr/data.dart';
import 'package:klymbr/view/drawer.dart' show LocalDrawer;
import 'package:klymbr/models/data.dart' show DataUser, Licences, Address;
import 'package:klymbr/models/fileio.dart' show Storage;
import 'package:klymbr/network/client.dart' show Connection;
import 'package:intl/intl.dart';
import 'package:klymbr/view/expantion_item.dart';

class UserView extends StatefulWidget {
  UserView({Key key}) : super(key: key);

  static const String routeWay = "/home";

  @override
  _UserViewState createState() => new _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  void initState() {
    new Storage("userdata").readJson().then((Map json) {
      if (json == null) {
        Navigator.pushNamed(context, "/");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new LocalDrawer(localRoute: "/"),
      appBar: new AppBar(
        title: new Text("Mon compte"),
      ),
      body: new _UserFormField(),
    );
  }
}

class _UserFormField extends StatefulWidget {
  _UserFormField({Key key}) : super(key: key);

  @override
  __UserFormFieldState createState() => new __UserFormFieldState();
}

class __UserFormFieldState extends State<_UserFormField> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _FrNumberTextInputFormatter _phoneNumberFormatter =
      new _FrNumberTextInputFormatter();
  final List<TextEditingController> _controllerList =
      new List.generate(8, (_) => new TextEditingController());
  ScrollController _scrollController;

  Future<List<ExpantionItem<dynamic>>> _expensionItems;

  DataUser _user;
  Address _address;
  String _userPicture;
  bool _autovalidate = false;
  bool _formWasEdited = false;

  Future<List<ExpantionItem<dynamic>>> get getExpensionItem async {
    List<dynamic> info =
        await new Storage("userlicences").readListJson();
    print("expension ");
    List<ExpantionItem<dynamic>> expensionItems = new List();
    print("userlicences = $info");

    info.forEach((data) {
      print("data = $data");
      expensionItems.add(new ExpantionItem<String>(
          name: "Licence",
          value: data["fed"],
          valueToString: (String value) => value,
          builder: (ExpantionItem<String> item) {
            void close() {
              setState(() {
                item.isExpanded = false;
              });
            }

            return new Column(
              children: <Widget>[
                new Container(
                  child: new Center(
                      child: new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Text("${data["status"]}"),
                          const SizedBox(height: 16.0),
                          new Text("Club ${data["clubname"]}"),
                          const SizedBox(height: 16.0),
                          new Text("Numero du club ${data["clubid"]}"),
                          const SizedBox(height: 16.0),
                          new Text("Valide jusqu'au ${data["end"]}"),
                        ],
                      )),
                    ],
                  )),
                )
              ],
            );
          }));
    });
    return new Future.value(expensionItems);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _controllerList[0].dispose();
    _controllerList[1].dispose();
    _controllerList[2].dispose();
    _controllerList[3].dispose();
    _controllerList[4].dispose();
    _controllerList[5].dispose();
    _controllerList[6].dispose();
    _controllerList[7].dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _user = new DataUser();
    _address = new Address();

    print("expension A");
    _expensionItems = getExpensionItem;

    print("read userdata");
    new Storage("userdata").readJson().then((Map json) {
      print("lecture dans User");
      print(json);
      _user = new DataUser.fromJson(json);
      if (_user != null) {
        setState(() {
          print("user != null");
          _controllerList[0].text =
              _user.lastname == null ? "" : _user.lastname;
          _controllerList[1].text =
              _user.firstname == null ? "" : _user.firstname;
          _controllerList[2].text =
              _user.licencenbr == null ? "" : _user.licencenbr;
          _controllerList[3].text = _user.phone == null ? "" : _user.phone;
          _userPicture = "images/daftpunk.jpg";
          _user.birthdate;
          _user.gender;
          print("setstate end");
        });
      }
    });
    print("read userdata = ");
    print("$_user");

    new Storage("useraddress").readJson().then((Map json) {
      _address = new Address.fromJson(json);
      print(_address);
      if (_address != null) {
        _controllerList[4].text =
            _address.number == null ? "" : _address.number.toString();
        _controllerList[5].text =
            _address.street == null ? "" : _address.street;
        _controllerList[6].text =
            _address.postalcode == null ? "" : _address.postalcode.toString();
        _controllerList[7].text = _address.city == null ? "" : _address.city;
      }
    });
    print("useraddress = ");
    print(_address);
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
      Connection connectionClient = new Connection();
      connectionClient
        ..token = globalToken
        ..patchRequest("/user/update", _user.toJson())
            .then((Map<String, dynamic> value) {
          print(showDialog<String>(
              context: context,
              child: new AlertDialog(
                  content: new Text("Mis à jour"),
                  actions: <Widget>[
                    new FlatButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.pop(context, value.toString());
                        })
                  ])));
        }).catchError((exeption) {
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
      print(_user.toJson());
      print(_address.toJson());
      showInSnackBar('${_user.lastname}\'s phone number is ${_user.phone}');
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
        controller: _scrollController,
        reverse: true,
        shrinkWrap: true,
        children: <Widget>[
          new Image.asset(
            _userPicture,
            width: 600.0,
            height: 240.0,
            fit: BoxFit.cover,
          ),
          new Container(
            padding: const EdgeInsets.only(right: 12.0),
//                padding: const EdgeInsets.all(20.0),
            alignment: Alignment.center,
            child: new DropdownButton<String>(
              value: _user.gender == null
                  ? "Monsieur"
                  : <String>["Monsieur", "Madame"][_user.gender],
              onChanged: (String newValue) {
                setState(() {
//                  if (_user != null)
                  if (newValue == "Monsieur") {
                    _user.gender = 0;
                  } else {
                    _user.gender = 1;
                  }
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
          new Container(
            padding: const EdgeInsets.only(right: 12.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  child: new TextFormField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: "Comment tu t'appel",
                      labelText: 'Nom *',
                    ),
                    controller: _controllerList[0],
                    onSaved: (String value) {
                      _user.lastname = value;
                    },
                    validator: _validateName,
                  ),
                ),
                const SizedBox(width: 16.0),
                new Expanded(
                  child: new TextFormField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: "Comment tu t'appel",
                      labelText: 'Prenom *',
                    ),
                    controller: _controllerList[1],
                    onSaved: (String value) {
                      _user.firstname = value;
                    },
                    validator: _validateName,
                  ),
                ),
              ],
            ),
          ),
          new Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 12.0, left: 12.0),
            child: new _DateTimePicker(
              labelText: 'Date de naissance',
              selectedDate: _user.birthdate == null
                  ? new DateTime.now()
                  : _user.birthdate,
              selectedTime: const TimeOfDay(hour: 7, minute: 28),
              selectDate: (DateTime date) {
                setState(() {
                  _user.birthdate = date;
                });
              },
              selectTime: (TimeOfDay time) {},
            ),
          ),
          new Container(
            padding: const EdgeInsets.only(right: 12.0),
            child: new TextFormField(
              autofocus: true,
              decoration: const InputDecoration(
                icon: const Icon(Icons.confirmation_number),
                prefixText: 'N°',
                hintText: "Licence",
                labelText: 'Licence *',
                prefixStyle: const TextStyle(color: Colors.red),
                suffixStyle: const TextStyle(color: Colors.red),
              ),
              controller: _controllerList[2],
              maxLines: 1,
              onSaved: (String value) {
                _user.licencenbr = value;
              },
              validator: _validateLicence,
            ),
          ),
          new Container(
            padding: const EdgeInsets.only(right: 12.0),
            child: new TextFormField(
              autofocus: true,
              decoration: const InputDecoration(
                  icon: const Icon(Icons.phone),
                  hintText: 'Where can we reach you?',
                  labelText: 'Phone Number *',
                  prefixText: '+33'),
              keyboardType: TextInputType.phone,
              controller: _controllerList[3],
              onSaved: (String value) {
                _user.phone = value;
              },
              validator: _validatePhoneNumber,
              // TextInputFormatters are applied in sequence.
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly,
                // Fit the validating format.
                _phoneNumberFormatter,
              ],
            ),
          ),
          new Container(
            padding: const EdgeInsets.only(left: 26.0, right: 16.0),
            alignment: Alignment.center,
            child: new Row(children: <Widget>[
              new Expanded(
                child: new TextFormField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Numero",
                    labelText: 'Numero de rue',
                  ),
                  keyboardType: TextInputType.number,
                  controller: _controllerList[4],
                  onSaved: (String value) {
                    _address.number = int.parse(value);
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              new Expanded(
                child: new TextFormField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Rue",
                    labelText: 'Nom de rue',
                  ),
                  controller: _controllerList[5],
                  onSaved: (String value) {
                    _address.street = value;
                  },
                ),
              ),
            ]),
          ),
          new Container(
            padding: const EdgeInsets.only(left: 26.0, right: 16.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    controller: _controllerList[6],
                    onSaved: (String value) {
                      _address.postalcode = int.parse(value);
                    },
                    decoration: const InputDecoration(
                      hintText: "Code Postal",
                      labelText: 'Code Postal',
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                new Expanded(
                  child: new TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    controller: _controllerList[7],
                    onSaved: (String value) {
                      _address.city = value;
                    },
                    decoration: const InputDecoration(
                      hintText: "Ville",
                      labelText: 'Nom de la Ville',
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.center,
            child: new Column(
              children: <Widget>[
                new RaisedButton(
                  child: const Text('Envoyer'),
                  onPressed: _handleSubmitted,
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
          new Container(
            child: new FutureBuilder(
                future: _expensionItems,
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return new ExpansionPanelList();
                    case ConnectionState.waiting:
                      return new ExpansionPanelList();
                    default:
                      return new ExpansionPanelList(
                        expansionCallback: (int index, bool isExpended) {
                          setState(() {
                            snapshot.data[index].isExpanded = !isExpended;
                          });
                        },
                        children: snapshot.data == null
                            ? const <ExpansionPanel>[]
                            // ignore: strong_mode_uses_dynamic_as_bottom
                            : snapshot.data.map((dynamic item) {
                                return new ExpansionPanel(
                                    isExpanded: item.isExpanded,
                                    headerBuilder: item.headerBuilder,
                                    body: item.builder(item));
                              }).toList(),
                      );
                  }
                }),
          ),
          new Container(
            padding: const EdgeInsets.only(top: 20.0),
            child: new Text('* champ obligatoire',
                style: Theme.of(context).textTheme.caption),
          ),
        ].reversed.toList(),
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
  const _DateTimePicker(
      {Key key,
      this.labelText,
      this.selectedDate,
      this.selectedTime,
      this.selectDate,
      this.selectTime})
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(1800, 8),
        lastDate: new DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) selectTime(picked);
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
            labelText: labelText,
            valueText: new DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
//        const SizedBox(width: 12.0),
//        new Expanded(
//          flex: 3,
//          child: new _InputDropdown(
//            valueText: selectedTime.format(context),
//            valueStyle: valueStyle,
//            onPressed: () { _selectTime(context); },
//          ),
//        ),
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
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
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
