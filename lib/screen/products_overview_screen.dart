import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myflutter/model/cart.dart';
import 'package:myflutter/widget/badge.dart';
import 'package:myflutter/widget/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProductsOverviewScreen();
}


class _ProductsOverviewScreen extends State<ProductsOverviewScreen> {
  bool _showFavoritesOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(value: FilterOptions.favorites, child: Text('Only favorites')),
              const PopupMenuItem(value: FilterOptions.all, child: Text('Show All')),
            ],
            onSelected: (FilterOptions selectedValue) => {
              setState(() {
                if (selectedValue == FilterOptions.favorites) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              })
            },
          ),
          Consumer<Cart>(
            builder: (ctx, cartData, __) => Badge(
              value: cartData.itemCount.toString(),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
      body: ProductsGrid(_showFavoritesOnly),
    );
  }

}