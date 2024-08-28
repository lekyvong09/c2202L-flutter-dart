import 'package:flutter/material.dart';
import 'package:myflutter/model/cart.dart';
import 'package:myflutter/model/order.dart';
import 'package:myflutter/provider/auth_provider.dart';
import 'package:myflutter/provider/product_provider.dart';
import 'package:myflutter/screen/admin_product_edit_screen.dart';
import 'package:myflutter/screen/admin_product_screen.dart';
import 'package:myflutter/screen/auth_screen.dart';
import 'package:myflutter/screen/cart_screen.dart';
import 'package:myflutter/screen/order_screen.dart';
import 'package:myflutter/screen/product_detail_screen.dart';
import 'package:myflutter/screen/products_overview_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductProvider()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        // ChangeNotifierProvider(create: (ctx) => Orders()),
        // ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, Orders>(
            create: (ctx) => Orders(Provider.of<AuthProvider>(ctx, listen: false).token, []),
            update: (ctx, auth, Orders? previous) => Orders((auth.token), previous!.orders),
        )
      ],
      child: Consumer<AuthProvider>(builder: (ctx, auth, _) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            fontFamily: 'Roboto',
            // primarySwatch: Colors.blue,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
              accentColor: Colors.deepOrangeAccent,
            )
        ),
        home: auth.isAuth ? const ProductsOverviewScreen() : const AuthScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrderScreen.routeName: (ctx) => const OrderScreen(),
          AdminProductScreen.routeName: (ctx) => const AdminProductScreen(),
          AdminProductEditScreen.routeName: (ctx) => const AdminProductEditScreen(),
          ProductsOverviewScreen.routeName: (ctx) => const ProductsOverviewScreen(),
        },
      ),) ,
    );
  }
}



