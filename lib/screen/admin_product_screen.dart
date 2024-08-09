


import 'package:flutter/material.dart';
import 'package:myflutter/provider/product_provider.dart';
import 'package:myflutter/widget/navbar_drawer.dart';
import 'package:provider/provider.dart';

class AdminProductScreen extends StatelessWidget {
  static const routeName = '/admin-product';

  const AdminProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Product'),),
      drawer: const NavbarDrawer(),
    );
  }

}