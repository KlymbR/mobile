import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

//"www.klymbr.com/api"
class Connection {
  static const String _url = "http://www.api.klymbr.com"; // URL to web API
  String _token;
  final _httpClient = http.Client();

  Connection();

  dynamic _extractData(http.Response resp) => json.decode(resp.body);

  Exception _handleError(dynamic e) {
    return new Exception(e);
  }

  set token(String tokenVal) {
    this._token = tokenVal;
  }
/*  --header "Content-Type: application/json" \
  --header "Authorization: bearer*/
  Future<Map<String, dynamic>> postRequest(
      [String url, Map<String, dynamic> params]) async {
    print("in post request");
    print(json.encoder.convert(params));
    try {
      final response = await _httpClient.post("$_url$url",
          headers:
                {
                  "Authorization": "bearer $_token",
                  "Content-Type": "application/json",
                  "Accept": "application/json",
                },
          body: json.encoder.convert(params));
      print("post ${response.body}");
      if (response.statusCode != 200) {
        throw "Probleme Serveur ${response.statusCode} ${response.body}";
      }
      return _extractData(response);
    } on SocketException catch (e) {
      throw "Probleme Serveur";
    } catch (e) {
      print(_handleError(e));
      throw "Probleme Serveur";
    }
  }

  Future<Map<String, dynamic>> getJson(String params) async {
    try {
      final response = await _httpClient.get("$_url$params",
          headers: _token == null
              ? null
              : {
                  "Authorization": "bearer $_token"
                });
      if (response.statusCode != 200) {
        throw "Probleme Serveur ${response.statusCode} ${response.body}";
      }
      print("resonses.body = ${response.body}");
      print("resonses.body = ${ _extractData(response)}");
      return _extractData(response);
    } on SocketException catch (e) {
      throw "Merci de verifier le reseau";
    } catch (e) {
      print("problemes getJson = ${e.toString()}");
      throw _handleError(e);
    }
  }

  Future<List<dynamic>> getJsonList(String params) async {
    try {
      final response = await _httpClient.get("$_url$params",
          headers: _token == null
              ? null
              : {
            "Authorization": "bearer $_token"
          });
      if (response.statusCode != 200) {
        throw "Probleme Serveur ${response.statusCode} ${response.body}";
      }
      print("resonses.body = ${response.body}");
      print("resonses.body = ${ _extractData(response)}");
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
            "Authorization": "bearer $_token",
            "Content-Type": "application/json",
          },
          body: json.encoder.convert(params));
      print("patch request  response = ${response.body}");
      if (response.statusCode != 200) {
        throw "Probleme Serveur ${response.statusCode} ${response.body}";
      }
      return _extractData(response);
    } on SocketException catch (e) {
      throw "Merci de verifier le reseau";
    } catch (e) {
      throw "Merci de verifier le reseau";
    }
  }
}
