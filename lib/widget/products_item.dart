
import 'package:flutter/material.dart';
import 'package:myflutter/model/cart.dart';
import 'package:myflutter/model/product.dart';
import 'package:myflutter/screen/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductsItem extends StatelessWidget {

  const ProductsItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = context.read<Product>();
    final cart = context.read<Cart>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id
        ),
        child: GridTile(
            header: GridTileBar(
              title: Text(product.name, textAlign: TextAlign.center, maxLines: 2,),
              backgroundColor: Colors.black54,
            ),
            footer: GridTileBar(
              title: Text(
                  '\$${product.unitPrice.toStringAsFixed(2)}',
                  textAlign: TextAlign.center
              ),
              backgroundColor: Colors.black54,
              leading: Consumer<Product>(builder: (ctx, item, child) =>
                IconButton(
                  icon: Icon(item.isFavorite ? Icons.favorite : Icons.favorite_border),
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () => product.toggleFavoriteStatus(),
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.shopping_cart),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  cart.addItem(product.id, product.unitPrice, product.name);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Added Item to cart'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () => cart.removeSingleItem(product.id),),
                    )
                  );
                },
              ),
            ),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            )
        ),
      ),
    );
  }


}