import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qrcode_reader/QRCodeReader.dart';

class QrView extends StatefulWidget {
  QrView({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _QrViewState createState() => new _QrViewState();
}

class _QrViewState extends State<QrView>{
  Future<String> _barcodeString;

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('QRCode Reader Example'),
      ),
      body: new Center(
          child: new FutureBuilder<String>(
              future: _barcodeString,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return new Text(snapshot.data != null ? snapshot.data : '');
              })),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          setState(() {
            _barcodeString = new QRCodeReader()
                .setAutoFocusIntervalInMs(200)
                .setForceAutoFocus(true)
                .setTorchEnabled(true)
                .setHandlePermissions(true)
                .setExecuteAfterPermissionGranted(true)
                .scan();
          });
        },
        tooltip: 'Reader the QRCode',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }
}

