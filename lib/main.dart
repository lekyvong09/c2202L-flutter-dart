import 'package:flutter/material.dart';
import 'package:myflutter/screen/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}
/// create widget products_item to break-down screen to widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductsOverviewScreen(),
    );
  }
}



