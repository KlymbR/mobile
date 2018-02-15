import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//"www.klymbr.com/api"
class Connection {
  static final _headers = {"Content-Type": "application/json"};
  final String _url; // URL to web API
  final httpClient = createHttpClient();

  Connection(this._url);

  dynamic _extractData(Response resp) => JSON.decode(resp.body);

  Exception _handleError(dynamic e) {
    return new Exception('Server error; cause: $e');
  }

  Future<Map<String, dynamic>> getJson() async {
    try {
      final response = await httpClient.get("$_url", headers: _headers);
      return _extractData(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
}
