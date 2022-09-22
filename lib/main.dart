import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';
import 'models/order_list.dart';
import 'models/product_list.dart';
import 'pages/cart_page.dart';
import 'pages/orders_page.dart';
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
      ],
      child: MaterialApp(
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
          AppRoutes.home: (_) => const ProductsOverviewPage(),
          AppRoutes.productsOverview: (_) => const ProductsOverviewPage(),
          AppRoutes.productDetail: (_) => const ProductDetailPage(),
          AppRoutes.cart: (_) => const CartPage(),
          AppRoutes.orders: (_) => const OrdersPage(),
        },
      ),
    );
  }
}
