import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'package:klymbr/data.dart';

//"www.klymbr.com/api"
class Connection {
  static const String _url = "http://www.api.klymbr.com"; // URL to web API
  String _token;
  final _httpClient = createHttpClient();

  Connection();

  dynamic _extractData(Response resp) => JSON.decode(resp.body);

//  Exception _handleError(dynamic e) {
//    return new Exception('Server error; cause: $e');
//  }

  set token(String tokenVal){
    this._token = tokenVal;
  }


  Future<Map<String, dynamic>> postRequest(
      [String url, Map<String, dynamic> params]) async {
    print(params);
//    try {
//      final response = await _httpClient.post("$_url$url",
//          headers: _token == null
//              ? null
//              : {
//            "Authorization": "JWT $_token",
//          },
//          body: params);
//      if (response.statusCode != 200) {
//        print(_extractData(response) + {"statusCode": response.statusCode});
//        return _extractData(response) + {"statusCode": response.statusCode};
//      }
//      return _extractData(response);
//    } catch (e) {
//      return {"server error": e.toString()};
//      //throw _handleError(e);
//    }
    return JSON.decode("{\"token\": \"AZERTYUI\"}");
  }

//  Future<Map<String, dynamic>> getJson(String params) async {
  dynamic getJson(String params) async {
//    try {
//      final response = await _httpClient.get("$_url$params",
//          headers: _token == null
//              ? null
//              : {
//                  "Authorization": "JWT $_token",
//                  "Content-type": "application/json"
//                });
//      if (response.statusCode != 200) {
//        print(_extractData(response) + {"statusCode": response.statusCode});
//        return _extractData(response) + {"statusCode": response.statusCode};
//      }
//      return _extractData(response);
//    } catch (e) {
//      return {"server error": e.toString()};
//    }
  return JSON.decode(serverdata);
  }

  Future<Map<String, dynamic>> patchRequest(
      [String url, Map<String, String> params]) async {
    try {
      final response = await _httpClient.patch("$_url$url",
          headers: {
            "Authorization": "JWT $_token",
          },
          body: params);
      if (response.statusCode != 200) {
        print(_extractData(response) + {"statusCode": response.statusCode});
        return _extractData(response) + {"statusCode": response.statusCode};
      }
      return _extractData(response);
    } catch (e) {
      return {"server error": e.toString()};
    }
  }
}
