
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productName =
        ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
        appBar: AppBar(
          title: Text(productName),
        )
    );
  }

}