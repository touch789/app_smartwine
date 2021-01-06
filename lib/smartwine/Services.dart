import 'dart:convert';
import 'package:http/http.dart' as http; // add the http plugin in pubspec.yaml file.
import '../model/classBouteille.dart';
import 'package:flutter/services.dart';

class Services {
  static const ROOT = 'http://172.20.10.2/vin.php';
  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_EMP_ACTION = 'ADD_EMP';
  static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  static const _DELETE_EMP_ACTION = 'DELETE_EMP';

  // Method to create the table Employees.
  static Future<String> createTable() async {
    try {
      // add the parameters to pass to the request.
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_ACTION;
      print(map);
      final response = await http.post(ROOT, body: 'action=CREATE_TABLE');
      print('Create Table Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<List<myBottle>> getBottles() async {
    try {
      print("getbottles");
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      String action = "GET_ALL";
      final http.Response response = await http.post(
          'http://192.168.56.1/vin.php?action=' + action);
      print('getbottle Response: ${response.body}');
      if (200 == response.statusCode) {
        List<myBottle> list = parseResponse(response.body);
        return list;
      } else {
        return List<myBottle>();
      }
    } catch (e) {
      return List<myBottle>(); // return an empty list on exception/error
    }
  }

  static Future<List<myBottle>> getspecificBottles(String search) async {
    try {
      print("getbottles");
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      String action = "GET_ALL";
      final http.Response response = await http.post(
          'http://192.168.56.1/vin.php?action=' + action + '&query=' + search);
      print('getBottles Response: ${response.body}');
      if (200 == response.statusCode) {
        List<myBottle> list = parseResponse(response.body);
        return list;
      } else {
        return List<myBottle>();
      }
    } catch (e) {
      return List<myBottle>(); // return an empty list on exception/error
    }
  }

  static List<myBottle> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<myBottle>((json) => myBottle.fromJson(json)).toList();
  }

}