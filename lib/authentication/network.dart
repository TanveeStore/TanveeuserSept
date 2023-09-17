import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanvi/util/app_const.dart';

class Network with ChangeNotifier {
  String baseUrl = AppConst.baseUrl;
  String? token;

  dynamic signUp(data, url) async {
    final fullUrl = baseUrl + url;
    return await http.post(Uri.parse(fullUrl),
        body: json.encode(data), headers: {'Content-Type': 'application/json'});
  }

  dynamic checkOtp(data, url) async {
    final fullUrl = baseUrl + url;
    return await http.post(Uri.parse(fullUrl),
        body: json.encode(data), headers: {'Content-Type': 'application/json'});
  }

  dynamic logIn(data, url) async {
    final fullUrl = baseUrl + url;
    return await http.post(Uri.parse(fullUrl),
        body: json.encode(data), headers: {'Content-Type': 'application/json'});
  }

  dynamic loginOtp(data, url) async {
    final fullUrl = baseUrl + url;
    return await http.post(Uri.parse(fullUrl),
        body: json.encode(data), headers: {'Content-Type': 'application/json'});
  }

  dynamic fcmToken(fcmToken) async {
    final fullUrl = baseUrl + 'api/fcm-token/';
    return await http.post(Uri.parse(fullUrl),
        body: json.encode({'fcm_token': fcmToken}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
  }

  dynamic logOut(data, url) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    final fullUrl = baseUrl + url;
    return await http
        .post(Uri.parse(fullUrl), body: json.encode(data), headers: {
      'Authorization': 'Bearer ${localStorage.getString('token')}',
      'Content-Type': 'application/json'
    });
  }

  dynamic getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('token');
    print('Access Token: $token');
    return token;
  }
}
