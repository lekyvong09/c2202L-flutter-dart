
import 'package:flutter/material.dart';
import 'package:myflutter/screen/product_detail_screen.dart';

class ProductsItem extends StatelessWidget {
  final int id;
  final String name;
  final String imageUrl;
  final double unitPrice;

  const ProductsItem({
    super.key,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.unitPrice
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: name
        ),
        child: GridTile(
            header: GridTileBar(
              title: Text(name, textAlign: TextAlign.center, maxLines: 2,),
              backgroundColor: Colors.black54,
            ),
            footer: GridTileBar(
              title: Text(
                  '\$${unitPrice.toStringAsFixed(2)}',
                  textAlign: TextAlign.center
              ),
              backgroundColor: Colors.black54,
              leading: IconButton(
                icon: const Icon(Icons.favorite),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {},
              ),
              trailing: IconButton(
                icon: const Icon(Icons.shopping_cart),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {},
              ),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            )
        ),
      ),
    );
  }


}