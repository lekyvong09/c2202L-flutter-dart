
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myflutter/model/product.dart';
import 'package:http/http.dart' as httpClient;

class ProductProvider with ChangeNotifier {
  final String authToken;
  List<Product> _items = [
    // Product(id: 1, name: 'Machine Learning: 4 Books in 1', description: 'An Overview for Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 o Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 o Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 o Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 o Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 o Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 o Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 o Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 o Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 o Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 o Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 o Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1 Beginners to Master Machine Learning: 4 Books in 1', unitPrice: 35.01, imageUrl: 'https://i.postimg.cc/rF9fSZg4/BOOK-PROGRAMMING-1011.jpg',),
    // Product(id: 2, name: 'Beginning Programming All-in-One', description: 'Desk Reference For Dummies', unitPrice: 32.89, imageUrl: 'https://i.postimg.cc/vBLVpk4L/BOOK-PROGRAMMING-1010.jpg',),
    // Product(id: 3, name: 'Head First Design Patterns', description: 'Building Extensible and Maintainable OOP', unitPrice: 32.43, imageUrl: 'https://i.postimg.cc/4NF9kzxM/BOOK-PROGRAMMING-1009.jpg',),
    // Product(id: 4, name: 'Effective C', description: 'An Introduction to Professional C Programming', unitPrice: 35.01, imageUrl: 'https://i.postimg.cc/sXyB9mTB/BOOK-PROGRAMMING-1008.jpg',),
    // Product(id: 5, name: 'Computer Programming: The Bible', description: 'Learn from the basics to advanced', unitPrice: 14.95, imageUrl: 'https://i.postimg.cc/4NMmFs8R/BOOK-PROGRAMMING-1007.jpg',),
    // Product(id: 6, name: 'The Self-Taught Programmer', description: 'The Definitive Guide to Programming', unitPrice: 21.87, imageUrl: 'https://i.postimg.cc/Dwk7XZj0/BOOK-PROGRAMMING-1006.jpg',),
    // Product(id: 7, name: 'Python Programming for Beginners', description: 'The Ultimate Guide for Beginners', unitPrice: 21.99, imageUrl: 'https://i.postimg.cc/wBFzZk6R/BOOK-PROGRAMMING-1005.jpg',),
  ];

  ProductProvider(this.authToken,this._items);

  List<Product> get items {
    return [..._items];
  }

  Product findById(int id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    var url = Uri.parse('http://localhost:8080/api/products');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $authToken'
    };

    try {
      final response = await httpClient.get(url);
      final extractedData = json.decode(response.body)['products'] as List<dynamic>;

      url = Uri.parse('http://localhost:8080/api/favorite');
      final favoriteResponse = await httpClient.get(url, headers: headers);
      Map<String, dynamic> favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadProducts = [];
      for (var element in extractedData) {
        loadProducts.add(Product(
          name: element['name'],
          description: element['description'],
          unitPrice: element['unitPrice'],
          imageUrl: element['imageUrl'],
          id: element['id'], isFavorite: favoriteData[element['id'].toString()] ?? false
        ));
      }
      _items = loadProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse('http://localhost:8080/api/products/add');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    try {
      final response = await httpClient.post(url, headers: headers, body: json.encode({
        'name': product.name,
        'description': product.description,
        'unitPrice': product.unitPrice,
        'imageUrl': product.imageUrl,
        'date': DateTime.now().toIso8601String(),
        'category': 'U',
      }));
      final res = json.decode(response.body);
      final newProduct = Product(
        name: res['name'],
        description: res['description'],
        unitPrice: res['unitPrice'],
        imageUrl: res['imageUrl'],
        id: res['id'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    final prodIndex = _items.indexWhere((element) => element.id == product.id);

    if (prodIndex > -1) {
      final url = Uri.parse('http://localhost:8080/api/products/update');
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': '*/*'
      };
      try {
        final response = await httpClient.post(url, headers: headers, body: json.encode({
          'name': product.name,
          'description': product.description,
          'unitPrice': product.unitPrice,
          'imageUrl': product.imageUrl,
          'date': DateTime.now().toIso8601String(),
          'id': product.id
        }));
        final res = json.decode(response.body);
        final updatedProduct = Product(
          name: res['name'],
          description: res['description'],
          unitPrice: res['unitPrice'],
          imageUrl: res['imageUrl'],
          id: res['id'],
        );
        _items[prodIndex] = updatedProduct;
        notifyListeners();
      } catch (error) {
        rethrow;
      }


      _items[prodIndex] = product;
      notifyListeners();
    } else {
      log('problem with update product');
    }
  }

  Future<void> deleteProduct(int id) async {
    final url = Uri.parse('http://localhost:8080/api/products/delete/$id');

    try {
      final response = await httpClient.delete(url);
      if (response.statusCode == 204) {
        _items.removeWhere((element) => element.id == id);
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
}