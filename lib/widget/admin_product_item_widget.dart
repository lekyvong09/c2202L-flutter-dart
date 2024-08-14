

import 'package:flutter/material.dart';
import 'package:myflutter/screen/admin_product_edit_screen.dart';

class AdminProductItemWidget extends StatelessWidget {
  final int id;
  final String title;
  final String imageUrl;

  const AdminProductItemWidget(this.id, this.title, this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl),),
      trailing: SizedBox (
        width: 100,
        child: Row(children: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
            onPressed: () =>
                Navigator.of(context).pushNamed(AdminProductEditScreen.routeName, arguments: id),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            onPressed: () {},
          ),
        ],),
      ),
    );
  }


}