import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'package:klymbr/data.dart';
import 'dart:io';

//"www.klymbr.com/api"
class Connection {
  static const String _url = "http://www.api.klymbr.com"; // URL to web API
  String _token;
  final _httpClient = createHttpClient();

  Connection();

  dynamic _extractData(Response resp) => JSON.decode(resp.body);

  Exception _handleError(dynamic e) {
    return new Exception(e);
  }

  set token(String tokenVal) {
    this._token = tokenVal;
  }

  Future<Map<String, dynamic>> postRequest(
      [String url, Map<String, dynamic> params]) async {
    print(JSON.encoder.convert(params));
    try {
      final response = await _httpClient.post("$_url$url",
          headers:
                {
                  "Authorization": "JWT $_token",
                  "Content-Type": "application/json",
                  "Accept": "application/json",
                },
          body: JSON.encoder.convert(params));
      print("post ${response.body}");
      if (response.statusCode != 200) {
        throw "Probleme Serveur ${response.statusCode} ${response.body}";
      }
      return _extractData(response);
    } on SocketException catch (e) {
      throw "Merci de verifier le reseau";
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getJson(String params) async {
    try {
      final response = await _httpClient.get("$_url$params",
          headers: _token == null
              ? null
              : {
                  "Authorization": "JWT $_token"
                });
      if (response.statusCode != 200) {
        throw "Probleme Serveur ${response.statusCode} ${response.body}";
      }
      print("resonses.body = ${response.body}");
      return _extractData(response);
    } on SocketException catch (e) {
      throw "Merci de verifier le reseau";
    } catch (e) {
      print("problemes getJson = ${e.toString()}");
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> patchRequest(
      [String url, Map<String, dynamic> params]) async {
    try {
      final response = await _httpClient.patch("$_url$url",
          headers: {
            "Authorization": "JWT $_token",
            "Content-Type": "application/json",
          },
          body: JSON.encoder.convert(params));
      print("patch request  response = ${response.body}");
      if (response.statusCode != 200) {
        throw "Probleme Serveur ${response.statusCode} ${response.body}";
      }
      return _extractData(response);
    } on SocketException catch (e) {
      throw "Merci de verifier le reseau";
    } catch (e) {
      throw _handleError(e);
    }
  }
}
