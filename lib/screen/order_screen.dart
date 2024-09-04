

import 'package:flutter/material.dart';
import 'package:myflutter/model/order.dart';
import 'package:myflutter/widget/navbar_drawer.dart';
import 'package:myflutter/widget/order_item_widget.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrderScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OrderScreen();
}

class _OrderScreen extends State<OrderScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      context.read<Orders>().fetchOrders();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<Orders>();

    return Scaffold(
      appBar: AppBar(title: const Text('Your orders'),),
      drawer: const NavbarDrawer(),
      body: ListView.builder(
        itemCount: orders.orders.length,
        itemBuilder: (ctx, idx) => OrderItemWidget(
          order: orders.orders[idx],
        ),
      ),
    );
  }


}