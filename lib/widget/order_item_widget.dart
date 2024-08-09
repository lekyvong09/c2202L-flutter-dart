

import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myflutter/model/order.dart';

class OrderItemWidget extends StatefulWidget {
  final Order order;

  const OrderItemWidget({required this.order, super.key});

  @override
  State<StatefulWidget> createState() => _OrderItemWidget();
}

class _OrderItemWidget extends State<OrderItemWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        ListTile (
          title: Text('\$ ${widget.order.totalPrice}'),
          subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
          trailing: IconButton(
            icon: const Icon(Icons.expand_more),
            onPressed: () => setState(() {_expanded = !_expanded;})
          ),
        ),

        if (_expanded)
          SizedBox(
            height: min(widget.order.cartItems.length * 20, 100),
            child: ListView(
                children: widget.order.cartItems.map((item) =>
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.name),
                        Text('${item.quantity}x \$${item.unitPrice}')
                      ],
                    )
                ).toList(),
              )
          )
      ],),
    );
  }
}