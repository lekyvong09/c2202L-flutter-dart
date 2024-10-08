

import 'package:flutter/material.dart';
import 'package:myflutter/provider/auth_provider.dart';
import 'package:myflutter/screen/admin_product_screen.dart';
import 'package:myflutter/screen/order_screen.dart';
import 'package:provider/provider.dart';

class NavbarDrawer extends StatelessWidget {
  const NavbarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(title: const Text('Menu'),),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payments_outlined),
            title: const Text('Orders'),
            onTap: () => Navigator.of(context).pushReplacementNamed(OrderScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop_rounded),
            title: const Text('Shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Product'),
            onTap: () => Navigator.of(context).pushReplacementNamed(AdminProductScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
    );
  }


}