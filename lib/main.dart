import 'package:flutter/material.dart';

import 'pages/product_detail_page.dart';
import 'pages/products_overview_page.dart';
import 'utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop',
      theme: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.pink[900],
              secondary: Colors.white,
              tertiary: Colors.black87,
            ),
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              centerTitle: true,
            ),
        fontFamily: 'Lato',
      ),
      routes: {
        AppRoutes.home: (_) => ProductsOverviewPage(),
        AppRoutes.productsOverview: (_) => ProductsOverviewPage(),
        AppRoutes.productDetail: (_) => const ProductDetailPage(),
      },
    );
  }
}
