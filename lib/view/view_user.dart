import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klymbr/view/drawer.dart' show LocalDrawer;
import 'package:klymbr/models/data.dart' show DataUser, Licences, Address;
import 'package:klymbr/models/fileio.dart' show Storage;
import 'package:klymbr/network/client.dart' show Connection;
import 'package:intl/intl.dart';
import 'package:klymbr/view/expantion_item.dart';

class UserView extends StatefulWidget {
  UserView({Key key}) : super(key: key);

  static const String routeWay = "/";

  @override
  _UserViewState createState() => new _UserViewState();
}

class _UserViewState extends State<UserView> {
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
//    Storage st = new Storage("userdata");
//    st.readJson().then((Map json) {
//      print(json.toString());
//      print("Utilisateur Json : ");
//      this._value = json;
//      print(this._value);
//    });
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
    List<Map<String, dynamic>> info =
        await new Storage("userlicences").readListJson();
    List<ExpantionItem<dynamic>> expensionItems = new List();
    print("userlicences = $info");

    info.forEach((Map<String, dynamic> data) {
      print("data = $data");
      expensionItems.add(new ExpantionItem<String>(
          name: "Licence",
          value: data["fednb"],
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
                          new Text("Numero du club ${data["clubnb"]}"),
                          const SizedBox(height: 16.0),
                          new Text("Valide jusqu'au ${data["enddate"]}"),
                        ],
                      )),
                    ],
                  )),
                )
              ],
            );
          }));
    });
    print("expensionItems = $expensionItems");
    return new Future.value(expensionItems);
  }

  @override
  void initState() {
    super.initState();
    _user = new DataUser();
    _address = new Address();
    _expensionItems = getExpensionItem;
    _userPicture = "";

    new Storage("userdata").readJson().then((Map json) {
      print("lecture dans User");
      print(json);
      _user = new DataUser.fromJson(json);
      if (_user != null) {
        _controllerList[0].text = _user.lastname;
        _controllerList[1].text = _user.firstName;
        _controllerList[2].text = _user.licenceNbr;
        _controllerList[3].text = _user.phone;
        setState(() {
          _userPicture = "images/daftpunk.jpg";
          _user.birthday;
          _user.genre;
        });
      }
    });

    new Storage("useraddress").readJson().then((Map json) {
      _address = new Address.fromJson(json);
      print(_address);
      if (_address != null) {
        _controllerList[4].text = _address.number;
        _controllerList[5].text = _address.way;
        _controllerList[6].text = _address.postalcode;
        _controllerList[7].text = _address.city;
      }
    });
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
              value: _user == null ? "Monsieur" : _user.genre,
              onChanged: (String newValue) {
                setState(() {
//                  if (_user != null)
                  _user.genre = newValue;
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
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: "Comment tu t'appel",
                      labelText: 'Nom *',
                    ),
                    controller: _controllerList[0],
                    initialValue: _user == null ? "" : _user.lastname,
                    onSaved: (String value) {
                      _user.lastname = value;
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
                    controller: _controllerList[1],
                    initialValue: _user == null ? "" : _user.firstName,
                    onSaved: (String value) {
                      _user.firstName = value;
                    },
                    validator: _validateName,
                  ),
                ),
              ],
            ),
          ),
          new Container(
            padding: const EdgeInsets.only(right: 12.0),
            child: new _DateTimePicker(
//            icon: const Icon(Icons.confirmation_number),
              labelText: 'Date de naissance',
              selectedDate: _user == null ? new DateTime.now() : _user.birthday,
              selectDate: (DateTime date) {
                setState(() {
//                _birthDate = date;
                  _user.birthday = date;
                });
              },
            ),
          ),
          new Container(
            padding: const EdgeInsets.only(right: 12.0),
            child: new TextFormField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.confirmation_number),
                prefixText: 'N°',
                hintText: "Licence",
                labelText: 'Licence *',
                prefixStyle: const TextStyle(color: Colors.red),
                suffixStyle: const TextStyle(color: Colors.red),
              ),
              initialValue: _user == null ? "" : _user.licenceNbr,
              controller: _controllerList[2],
              maxLines: 1,
              onSaved: (String value) {
                _user.licenceNbr = value;
              },
              validator: _validateLicence,
            ),
          ),
          new Container(
            padding: const EdgeInsets.only(right: 12.0),
            child: new TextFormField(
              decoration: const InputDecoration(
                  icon: const Icon(Icons.phone),
                  hintText: 'Where can we reach you?',
                  labelText: 'Phone Number *',
                  prefixText: '+33'),
              keyboardType: TextInputType.phone,
              initialValue: _user == null ? "" : _user.phone,
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
                  decoration: const InputDecoration(
                    hintText: "Numero",
                    labelText: 'Numero de rue',
                  ),
                  keyboardType: TextInputType.number,
                  controller: _controllerList[4],
                  initialValue: _address == null ? "" : _address.number,
                  onSaved: (String value) {
                    _address.number = value;
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              new Expanded(
                child: new TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Rue",
                    labelText: 'Nom de rue',
                  ),
                  controller: _controllerList[5],
                  initialValue: _address == null ? "" : _address.way,
                  onSaved: (String value) {
                    _address.way = value;
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
                    keyboardType: TextInputType.number,
                    controller: _controllerList[6],
                    initialValue: _address == null ? "" : _address.postalcode,
                    onSaved: (String value) {
                      _address.postalcode = value;
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
                    keyboardType: TextInputType.text,
                    controller: _controllerList[7],
                    initialValue: _address == null ? "" : _address.city,
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
                      print(snapshot.data);
                      return new ExpansionPanelList(
                        expansionCallback: (int index, bool isExpended) {
                          setState(() {
                            snapshot.data[index].isExpanded = !isExpended;
                          });
                        },
                        children: snapshot.data == null
                            ? const <ExpansionPanel>[]
                            : snapshot.data.map((ExpantionItem<dynamic> item) {
                                print("Expention = ${item.name}");
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
