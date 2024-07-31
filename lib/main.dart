import 'package:flutter/material.dart';
import 'package:myflutter/model/cart.dart';
import 'package:myflutter/provider/product_provider.dart';
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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            fontFamily: 'Roboto',
            // primarySwatch: Colors.blue,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
              accentColor: Colors.deepOrangeAccent,
            )
        ),
        home: const ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen()
        },
      ),
    );
  }
}



