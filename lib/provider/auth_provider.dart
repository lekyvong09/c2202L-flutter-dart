
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as httpClient;

class AuthProvider with ChangeNotifier {
  
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
  
}