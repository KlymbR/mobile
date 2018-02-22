import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class Storage {
  final String _filename;

  Storage(this._filename);

  Future<File> _getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/$_filename');
  }

  Future<Map<String, dynamic>> readJson() async {
    try {
      return JSON.decode((await _getLocalFile()).readAsStringSync());
    } on FileSystemException {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> readListJson() async {
    try {
      return JSON.decode((await _getLocalFile()).readAsStringSync());
    } on FileSystemException {
      return null;
    }
  }

  Future<String> read() async {
    try {
      return (await _getLocalFile()).readAsStringSync();
    } on FileSystemException {
      return null;
    }
  }

  Future<Null> writeJson(var data) async {
    (await this._getLocalFile()).writeAsStringSync(JSON.encode(data.toJson()));
  }

  Future<Null> write(var data) async {
    (await this._getLocalFile()).writeAsStringSync(JSON.encode(data));
  }

}
