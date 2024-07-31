

import 'package:flutter/material.dart';
import 'package:myflutter/provider/product_provider.dart';
import 'package:myflutter/widget/products_item.dart';
import 'package:provider/provider.dart';


class ProductsGrid extends StatelessWidget {
  final bool _showFavoritesOnly;
  const ProductsGrid(this._showFavoritesOnly, {super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = context.watch<ProductProvider>();
    final products = _showFavoritesOnly ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2/3,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemBuilder: (ctx, idx) =>
          ChangeNotifierProvider.value(
            value: products[idx],
            child: const ProductsItem(),
          )

    );
  }

}