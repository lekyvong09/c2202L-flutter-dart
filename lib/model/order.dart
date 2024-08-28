
import 'package:flutter/material.dart';

import 'cart.dart';

class Order {
  final String orderTrackingNumber;
  final double totalPrice;
  final List<CartItem> cartItems;
  final DateTime dateTime;

  Order({
    required this.orderTrackingNumber,
    required this.totalPrice,
    required this.cartItems,
    required this.dateTime
  });
}

class Orders with ChangeNotifier {
  final String authToken;
  List<Order> _orders = [];

  Orders(this.authToken, this._orders);

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartItems, double total) {
    final url = Uri.parse('http://localhost:8080/api/checkout');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer .....',
    };
    _orders.insert(
        0,
        Order(
          orderTrackingNumber: DateTime.now().microsecondsSinceEpoch.toString(),
          totalPrice: total,
          dateTime: DateTime.now(),
          cartItems: cartItems
        ));

    notifyListeners();
  }
}