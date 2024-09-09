
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as httpClient;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';
  DateTime _expiryDate = DateTime.now();
  Timer _authTimer = Timer(const Duration(seconds: 0), () {});

  String get token {
    if (_token != '' && !Jwt.isExpired(_token)) {
      return _token;
    }
    return '';
  }

  bool get isAuth {
    return token != '';
  }

  
  Future<void> signup(String email, String password) async {
    final url = Uri.parse('http://localhost:8080/api/user/register');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
    };

    try {
      final response = await httpClient.post(url, headers: headers, body: json.encode({
        'email': email,
        'password': password
      }));
      final res = json.decode(response.body);
      log(res.toString());
      notifyListeners();
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }


  Future<void> login(String email, String password) async {
    final url = Uri.parse('http://localhost:8080/api/user/login');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
    };

    try {
      final response = await httpClient.post(url, headers: headers, body: json.encode({
        'email': email,
        'password': password
      }));
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      }
      final res = json.decode(response.body);
      _token = res['token'];
      _expiryDate = Jwt.getExpiryDate(_token)!;
      _autoLogout();
      final preferences = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'expiryDate': _expiryDate.toIso8601String()
      });
      preferences.setString('userData', userData);
      notifyListeners();
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }


  Future<bool> tryAutoLogin() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('userData')) {
      return false;
    }
    final extractedUserDate =
          json.decode(preferences.getString('userData') as String) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserDate['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserDate['token'];
    _expiryDate = expiryDate;
    _autoLogout();
    notifyListeners();
    return true;
  }


  Future<void> logout() async {
    _token = '';
    _authTimer.cancel();
    final preferences = await SharedPreferences.getInstance();
    preferences.clear();
    notifyListeners();
  }

  void _autoLogout() {
    _authTimer.cancel();
    var timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }


}