import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as httpClient;
import 'package:myflutter/model/HttpException.dart';

class Product with ChangeNotifier {
  final int id;
  final String name;
  final String description;
  final double unitPrice;
  final String imageUrl;
  bool isFavorite;

  Product({
      required this.id,
      required this.name,
      required this.description,
      required this.unitPrice,
      required this.imageUrl,
      this.isFavorite = false
  });

  Future<void> toggleFavoriteStatus(String token) {
    final url = Uri.parse('http://localhost:8080/api/favorite');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };
    return httpClient.post (url, headers: headers, body: json.encode({
      'productId': id,
      'favorite': !isFavorite
    }))
    .then((response) {
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      }
      isFavorite = !isFavorite;
      notifyListeners();
    }).catchError((error) => throw error);

    isFavorite = !isFavorite;
    notifyListeners();
  }

}